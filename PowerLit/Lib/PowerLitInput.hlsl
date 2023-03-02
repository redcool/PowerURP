#if !defined(POWER_LIT_INPUT_HLSL)
#define POWER_LIT_INPUT_HLSL

#include "PowerLitCommon.hlsl"

TEXTURE2D(_MetallicMask); SAMPLER(sampler_MetallicMask);
TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);
TEXTURE2D(_NormalMap);SAMPLER(sampler_NormalMap);
TEXTURE2D(_MetallicMaskMap); SAMPLER(sampler_MetallicMaskMap);
TEXTURE2D(_EmissionMap); SAMPLER(sampler_EmissionMap);

TEXTURECUBE(_IBLCube); SAMPLER(sampler_IBLCube);
TEXTURE2D(_ReflectionTex);SAMPLER(sampler_ReflectionTex); // planer reflection camera, use screenUV
TEXTURE2D(_ParallaxMap);SAMPLER(sampler_ParallaxMap);
TEXTURE2D(_RippleTex);SAMPLER(sampler_RippleTex);
TEXTURE2D(_CameraDepthTexture);SAMPLER(sampler_CameraDepthTexture);

TEXTURE2D(_CameraOpaqueTexture);SAMPLER(sampler_CameraOpaqueTexture);
TEXTURECUBE(_RainCube);SAMPLER(sampler_RainCube);
TEXTURE2D(_StoreyLineNoiseMap);SAMPLER(sampler_StoreyLineNoiseMap);

UNITY_INSTANCING_BUFFER_START(UnityPerMaterial)
//--------------------------------- Main
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_BaseMap_ST)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_Color)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_NormalMap_ST)

    UNITY_DEFINE_INSTANCED_PROP(float ,_NormalScale)
    UNITY_DEFINE_INSTANCED_PROP(float ,_Metallic)
    UNITY_DEFINE_INSTANCED_PROP(float ,_Smoothness)
    UNITY_DEFINE_INSTANCED_PROP(float ,_Occlusion)
    UNITY_DEFINE_INSTANCED_PROP(int ,_InvertSmoothnessOn)
    UNITY_DEFINE_INSTANCED_PROP(int ,_MetallicChannel)
    UNITY_DEFINE_INSTANCED_PROP(int ,_SmoothnessChannel)
    UNITY_DEFINE_INSTANCED_PROP(int ,_OcclusionChannel)
    // UNITY_DEFINE_INSTANCED_PROP(float ,_ClipOn) // to UNITY_DEFINE_INSTANCED_PROP(keyword ,_ALPHATEST_ON)
    UNITY_DEFINE_INSTANCED_PROP(float ,_Cutoff)
//--------------------------------- Emission
    // UNITY_DEFINE_INSTANCED_PROP(float ,_EmissionOn) // to UNITY_DEFINE_INSTANCED_PROP(keyword ,_EMISSION)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_EmissionColor)

    UNITY_DEFINE_INSTANCED_PROP(float ,_AlphaPremultiply) // ,_ALPHA_PREMULTIPLY_ON)
    // UNITY_DEFINE_INSTANCED_PROP(float ,_IsReceiveShadowOn) // to UNITY_DEFINE_INSTANCED_PROP(keyword ,_RECEIVE_SHADOWS_OFF)
//--------------------------------- IBL
    // UNITY_DEFINE_INSTANCED_PROP(float ,_IBLOn) //,_IBL_ON)
    UNITY_DEFINE_INSTANCED_PROP(float ,_EnvIntensity)
    UNITY_DEFINE_INSTANCED_PROP(float ,_IBLMaskMainTexA)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_ReflectDirOffset)
//--------------------------------- Custom Light
    // UNITY_DEFINE_INSTANCED_PROP(float ,_CustomLightOn) //,_CUSTOM_LIGHT_ON)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_CustomLightDir)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_CustomLightColor)

    UNITY_DEFINE_INSTANCED_PROP(float ,_FresnelIntensity)
//--------------------------------- lightmap
    UNITY_DEFINE_INSTANCED_PROP(float ,_LightmapSHAdditional)
    UNITY_DEFINE_INSTANCED_PROP(float ,_LMSaturateAdditional)
    UNITY_DEFINE_INSTANCED_PROP(float ,_LMIntensityAdditional)    
//--------------------------------- Wind
    UNITY_DEFINE_INSTANCED_PROP(float ,_WindOn)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_WindAnimParam)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_WindDir)
    UNITY_DEFINE_INSTANCED_PROP(float ,_WindSpeed)
//--------------------------------- Plannar Reflection
    // UNITY_DEFINE_INSTANCED_PROP(float ,_PlanarReflectionOn) // ,_PLANAR_REFLECTION_ON)
//--------------------------------- Rain
    UNITY_DEFINE_INSTANCED_PROP(float ,_SnowOn)
    UNITY_DEFINE_INSTANCED_PROP(float ,_SnowIntensity)
    UNITY_DEFINE_INSTANCED_PROP(float ,_ApplyEdgeOn)
//--------------------------------- Fog
    UNITY_DEFINE_INSTANCED_PROP(float ,_FogOn)
    UNITY_DEFINE_INSTANCED_PROP(float ,_FogNoiseOn)
    UNITY_DEFINE_INSTANCED_PROP(float ,_DepthFogOn)
    UNITY_DEFINE_INSTANCED_PROP(float ,_HeightFogOn)
//--------------------------------- Parallax
    // UNITY_DEFINE_INSTANCED_PROP(float ,_ParallaxOn) // to UNITY_DEFINE_INSTANCED_PROP(keyword ,_PARALLAX)
    UNITY_DEFINE_INSTANCED_PROP(float ,_ParallaxHeight)
    UNITY_DEFINE_INSTANCED_PROP(int ,_ParallaxMapChannel)
//--------------------------------- Rain
    UNITY_DEFINE_INSTANCED_PROP(int ,_RainOn)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_RippleTex_ST)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RippleSpeed)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RainSlopeAtten)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RippleIntensity)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RippleBlendNormalOn)

    UNITY_DEFINE_INSTANCED_PROP(float4 ,_RainColor)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RainSmoothness)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RainMetallic)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_RainCube_HDR)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_RainCube_ST)
    UNITY_DEFINE_INSTANCED_PROP(float3 ,_RainReflectDirOffset)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RainHeight)
    UNITY_DEFINE_INSTANCED_PROP(float ,_RainReflectIntensity)
    UNITY_DEFINE_INSTANCED_PROP(float ,_SurfaceDepth)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_BelowColor)

    UNITY_DEFINE_INSTANCED_PROP(float ,_StoreyTilingOn)
    UNITY_DEFINE_INSTANCED_PROP(float4 ,_StoreyWindowInfo)
    UNITY_DEFINE_INSTANCED_PROP(float,_StoreyLightSwitchSpeed)
    UNITY_DEFINE_INSTANCED_PROP(float,_StoreyHeight)
    UNITY_DEFINE_INSTANCED_PROP(float,_StoreyLineOn)
    
    UNITY_DEFINE_INSTANCED_PROP(float4,_StoreyLineColor)
    
    
UNITY_INSTANCING_BUFFER_END(UnityPerMaterial)

#define IsRainOn() (_IsGlobalRainOn && _RainOn)
#define IsSnowOn() (_IsGlobalSnowOn && _SnowOn)
#define IsWindOn() (_IsGlobalWindOn && _WindOn)

// #if (SHADER_LIBRARY_VERSION_MAJOR < 12)
// this block must define in UnityPerDraw cbuffer, change UnityInput.hlsl
// float4 unity_SpecCube0_BoxMax;          // w contains the blend distance
// float4 unity_SpecCube0_BoxMin;          // w contains the lerp value
// float4 unity_SpecCube0_ProbePosition;   // w is set to 1 for box projection
// float4 unity_SpecCube1_BoxMax;          // w contains the blend distance
// float4 unity_SpecCube1_BoxMin;          // w contains the sign of (SpecCube0.importance - SpecCube1.importance)
// float4 unity_SpecCube1_ProbePosition;   // w is set to 1 for box projection
// #endif

//--------------------------------- Main
    #define _BaseMap_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_BaseMap_ST)
    #define _Color UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Color)
    #define _NormalMap_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_NormalMap_ST)
    
    #define _NormalScale UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_NormalScale)
    #define _Metallic UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Metallic)
    #define _Smoothness UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Smoothness)
    #define _Occlusion UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Occlusion)
    #define _InvertSmoothnessOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_InvertSmoothnessOn)
    #define _MetallicChannel UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_MetallicChannel)
    #define _SmoothnessChannel UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_SmoothnessChannel)
    #define _OcclusionChannel UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_OcclusionChannel)
    // #define _ClipOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ClipOn) // to keyword _ALPHATEST_ON
    #define _Cutoff UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_Cutoff)
//--------------------------------- Emission
    // #define _EmissionOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_EmissionOn) // to keyword _EMISSION
    #define _EmissionColor UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_EmissionColor)

    #define _AlphaPremultiply UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_AlphaPremultiply) // _ALPHA_PREMULTIPLY_ON
    // #define _IsReceiveShadowOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_IsReceiveShadowOn) // to keyword _RECEIVE_SHADOWS_OFF
//--------------------------------- IBL
    // #define _IBLOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_IBLOn) //_IBL_ON
    #define _EnvIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_EnvIntensity)
    #define _IBLMaskMainTexA UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_IBLMaskMainTexA)
    #define _ReflectDirOffset UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ReflectDirOffset)
//--------------------------------- Custom Light
    // #define _CustomLightOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_CustomLightOn) //_CUSTOM_LIGHT_ON
    #define _CustomLightDir UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_CustomLightDir)
    #define _CustomLightColor UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_CustomLightColor)

    #define _FresnelIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FresnelIntensity)
//--------------------------------- lightmap
    #define _LightmapSHAdditional UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_LightmapSHAdditional)
    #define _LMSaturateAdditional UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_LMSaturateAdditional)
    #define _LMIntensityAdditional UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_LMIntensityAdditional)    
//--------------------------------- Wind
    #define _WindOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindOn)
    #define _WindAnimParam UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindAnimParam)
    #define _WindDir UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindDir)
    #define _WindSpeed UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_WindSpeed)
//--------------------------------- Plannar Reflection
    // #define _PlanarReflectionOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_PlanarReflectionOn) // _PLANAR_REFLECTION_ON
//--------------------------------- Rain
    #define _SnowOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_SnowOn)
    #define _SnowIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_SnowIntensity)
    #define _ApplyEdgeOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ApplyEdgeOn)
//--------------------------------- Fog
    #define _FogOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FogOn)
    #define _FogNoiseOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_FogNoiseOn)
    #define _DepthFogOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_DepthFogOn)
    #define _HeightFogOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_HeightFogOn)
//--------------------------------- Parallax
    // #define _ParallaxOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ParallaxOn) // to keyword _PARALLAX
    #define _ParallaxHeight UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ParallaxHeight)
    #define _ParallaxMapChannel UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_ParallaxMapChannel)
//--------------------------------- Rain
    #define _RainOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainOn)
    #define _RippleTex_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RippleTex_ST)
    #define _RippleSpeed UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RippleSpeed)
    #define _RainSlopeAtten UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainSlopeAtten)
    #define _RippleIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RippleIntensity)
    #define _RippleBlendNormalOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RippleBlendNormalOn)

    #define _RainColor UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainColor)
    #define _RainSmoothness UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainSmoothness)
    #define _RainMetallic UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainMetallic)
    #define _RainCube_HDR UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainCube_HDR)
    #define _RainCube_ST UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainCube_ST)
    #define _RainReflectDirOffset UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainReflectDirOffset)
    #define _RainHeight UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainHeight)
    #define _RainReflectIntensity UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_RainReflectIntensity)
    #define _SurfaceDepth UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_SurfaceDepth)
    #define _BelowColor UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_BelowColor)

    #define _StoreyTilingOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyTilingOn)
    #define _StoreyWindowInfo UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyWindowInfo)
    #define _StoreyLightSwitchSpeed UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyLightSwitchSpeed)
    #define _StoreyHeight UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyHeight)
    #define _StoreyLineColor UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyLineColor)

    #define _StoreyLineOn UNITY_ACCESS_INSTANCED_PROP(UnityPerMaterial,_StoreyLineOn)

#endif //POWER_LIT_INPUT_HLSL