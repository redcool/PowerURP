#if !defined(GI_HLSL)
#define GI_HLSL
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceData.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

float3 SampleLightmap(float2 lightmapUV){
    float3 lmap = 0;
    #if defined(UNITY_LIGHTMAP_FULL_HDR)
        bool encodedLightmap = false;
    #else
        bool encodedLightmap = true;
    #endif
    
    float4 decodeInstructions = float4(LIGHTMAP_HDR_MULTIPLIER,LIGHTMAP_HDR_EXPONENT,0,0);
    float4 transformUV = float4(1,1,0,0);
    lmap = SampleSingleLightmap(TEXTURE2D_LIGHTMAP_ARGS(LIGHTMAP_NAME,LIGHTMAP_SAMPLER_NAME),lightmapUV,transformUV,encodedLightmap,decodeInstructions);
    return lmap;
}
/**
    lerp(lmap, sh ,t)
*/
float3 CalcLightmapAndSH(float3 normal,float2 lightmapUV,float lightmapOrSH,float lmSaturate,float lmIntensity){
    
    #if defined(LIGHTMAP_ON)
    // branch_if(IsLightmapOn())
    {
        float3 lmap = 0;
        lmap = SampleLightmap(lightmapUV) * lmIntensity;
        lmap = lerp(Gray(lmap),lmap,lmSaturate);
        return lmap;
    }
    #else
        float3 sh = SampleSH(normal);
        return sh;
    #endif
    // return lerp(lmap,sh,lightmapOrSH);
}

float3 CalcFresnel(BRDFData brdfData,float nv){
    // float nv = saturate(dot(normal,viewDir));
    float fresnelTerm = Pow4(1-nv);
    float surfaceReduction = 1/(brdfData.roughness2 +1); //roughness[0,1] -> [1,0.5]
    float3 fresnel = surfaceReduction * lerp(brdfData.specular,brdfData.grazingTerm,fresnelTerm);
    return fresnel;
}

float3 CalcIBL(float3 reflectDir,TEXTURECUBE_PARAM(cube,sampler_Cube),float perceptualRoughness,float4 hdrEncode){
    // float mip = PerceptualRoughnessToMipmapLevel(perceptualRoughness);
    float mip = (6 * perceptualRoughness * (1.7-0.7 * perceptualRoughness)); // r * (1.7-0.7r)
    float4 encodeIBL = SAMPLE_TEXTURECUBE_LOD(cube,sampler_Cube,reflectDir,mip);
    #if defined(UNITY_USE_NATIVE_HDR) || defined(UNITY_DOTS_INSTANTING_ENABLED)
        float3 specGI = encodeIBL.rgb;
    #else // mobile
        float3 specGI = DecodeHDREnvironment(encodeIBL,hdrEncode);//_IBLCube_HDR,unity_SpecCube0_HDR
    #endif
    return specGI;
    // return _GlossyEnvironmentColor.rgb;
}


float3 CalcIBL(float3 reflectDir,float perceptualRoughness,float customIBLMask){

    float3 iblColor = 0;
    
    #if defined(_IBL_ON)
    {
        iblColor = CalcIBL(reflectDir,_IBLCube,sampler_IBLCube,perceptualRoughness,_IBLCube_HDR);
    }
    #else
    {
        iblColor =  CalcIBL(reflectDir,unity_SpecCube0,samplerunity_SpecCube0,perceptualRoughness,unity_SpecCube0_HDR);
    }
    #endif
    return lerp(1, iblColor,customIBLMask);
}

float4 SamplePlanarReflectionTex(float2 suv){
    return SAMPLE_TEXTURE2D(_ReflectionTexture,sampler_ReflectionTexture,suv);
}

#define REFLECT_MODE_INTERIROR_MAP 1

float3 CalcGI(BRDFData brdfData,float3 bakedGI,float occlusion,float3 normal,float3 viewDir,float customIBLMask,float3 worldPos,SurfaceInputData data){
    float3 indirectDiffuse = bakedGI  * brdfData.diffuse;

    float3 reflectDir = 0;
    float rough = brdfData.perceptualRoughness;

    #if defined(_INTERIOR_MAP_ON)
    {
        float2 uvRange = float2(_ReflectDirOffset.w,1 - _ReflectDirOffset.w);
        reflectDir = CalcInteriorMapReflectDir(data.viewDirTS,data.uv,uvRange);
        rough = lerp(0.5,rough,UVBorder(data.uv,uvRange));
        // reflectDir.z*=-1;
    }
    #else
        reflectDir = CalcReflectDir(worldPos,normal,viewDir,0);
    #endif

    // apply offset
    reflectDir+=_ReflectDirOffset.xyz + data.rainReflectDirOffset;

    float3 indirectSpecular  = CalcIBL(reflectDir,rough,customIBLMask);
    // indirectSpecular = lerp(indirectSpecular,1,UVBorder(data.uv,float2(_ReflectDirOffset.w,1 - _ReflectDirOffset.w)));

    #if defined(_PLANAR_REFLECTION_ON)
    // branch_if(_PlanarReflectionOn)
    {
        float4 planarReflectColor = SamplePlanarReflectionTex(data.screenUV+data.rainReflectDirOffset.xz);
        indirectSpecular = lerp(indirectSpecular,planarReflectColor.xyz,planarReflectColor.w);
    }
    #endif

    float3 fresnel = CalcFresnel(brdfData,data.nv);
    float3 color = indirectDiffuse + indirectSpecular * fresnel * data.envIntensity ;
    color *= occlusion;
    return color;
}

float CalcFresnelTerm(float nv,half2 fresnelRange=half2(0,1)){
    float fresnelTerm = Pow4(1 - nv);
    fresnelTerm = smoothstep(fresnelRange.x,fresnelRange.y,fresnelTerm);
    return fresnelTerm;
}

half3 CalcGISpec(float a2,float smoothness,float metallic,float fresnelTerm,half3 specColor,half3 iblColor,half3 grazingTermColor=1){
    float surfaceReduction = 1/(a2+1);
    float grazingTerm = saturate(smoothness+metallic);
    float3 giSpec = iblColor * surfaceReduction * lerp(specColor,grazingTermColor * grazingTerm,fresnelTerm);
    return giSpec;
}

/**
    _PLANAR_REFLECTION_ON, if use planar reflection
*/

half3 CalcGISpec(TEXTURECUBE_PARAM(cube,sampler_cube),float4 cubeHDR,float3 specColor,
    float3 worldPos,float3 normal,float3 viewDir,float3 reflectDirOffset,float reflectIntensity,
    float nv,float roughness,float a2,float smoothness,float metallic,half2 fresnelRange=half2(0,1),half3 grazingTermColor=1,
    // planar reflection tex,(xyz:color,w: ratio)
    half4 planarReflectTex=0)
{
    float3 reflectDir = CalcReflectDir(worldPos,normal,viewDir,reflectDirOffset);
    float3 iblColor = CalcIBL(reflectDir,cube,sampler_cube,roughness,cubeHDR) * reflectIntensity;

    #if defined(_PLANAR_REFLECTION_ON)
        // blend planar reflection texture
        iblColor = lerp(iblColor,planarReflectTex.xyz,planarReflectTex.w);
    #endif
    
    float fresnelTerm = CalcFresnelTerm(nv,fresnelRange);
    float3 giSpec = CalcGISpec(a2,smoothness,metallic,fresnelTerm,specColor,iblColor,grazingTermColor);
    return giSpec;
}

float3 CalcGIDiff(float3 normal,float3 diffColor,float2 lightmapUV=0){
    float3 giDiff = 0;
    #if defined(LIGHTMAP_ON)
        giDiff = SampleLightmap(lightmapUV) * diffColor;
    #else
        giDiff = SampleSH(normal) * diffColor;
    #endif
    return giDiff;
}

#endif // GI_HLSL