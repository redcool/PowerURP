#if !defined(PBR_INPUT_HLSL)
#define PBR_INPUT_HLSL
#include "../../PowerShaderLib/Lib/UnityLib.hlsl"

//for compatible PowerLit
#define _PbrMask _MetallicMaskMap
#define _MainTex _BaseMap
#define _MainTex_ST _BaseMap_ST

sampler2D _MainTex;
sampler2D _NormalMap;
sampler2D _PbrMask;
sampler2D _EmissionMap;
sampler2D _ReflectionTexture;

TEXTURE2D(_RippleTex);SAMPLER(sampler_RippleTex);
TEXTURECUBE(_IBLCube); SAMPLER(sampler_IBLCube);
TEXTURE2D(_DetailPBRMaskMap);SAMPLER(sampler_DetailPBRMaskMap);

CBUFFER_START(UnityPerMaterial)
half4 _Color;
half4 _MainTex_ST;
// half4 _Metallic_Smoothness_Occlusion_NormalScale;
half _Metallic,_Smoothness,_Occlusion,_NormalScale;
half _AlbedoMulVertexColor;

half _SpecularOn;
half _AnisoRough;
half _AnisoShift;

half _PbrMode;
half _CalcTangent;

// custom shadow 
half _MainLightShadowSoftScale;
half _CustomShadowDepthBias,_CustomShadowNormalBias;

// half _CalcAdditionalLights,_ReceiveAdditionalLightShadow,_AdditionalIghtSoftShadow;

//thin film
// half _TFOn,_TFScale,_TFOffset,_TFSaturate,_TFBrightness;
half _ReceiveShadowOff;
//----------------------------------------
half _FogOn;
half _FogNoiseOn;
half _DepthFogOn;
half _HeightFogOn;
//----------------------------------------
half _AlphaPremultiply;
half _Cutoff;

half4 _EmissionColor;
half2 _ClothRange;

//----------------------------------------
half4 _WindAnimParam;
half4 _WindDir;
half _WindSpeed;

half _SnowIntensity;
half _ApplyEdgeOn;

half4 _RippleTex_ST;
half _RippleOffsetAutoStop;
half _RippleAlbedoIntensity;
half _RippleSpeed;
half _RippleIntensity;
half _RippleBlendNormal;

half4 _RainColor;
half _RainSmoothness;
half _RainMetallic;
half _RainIntensity;
half _RainHeight;
half _RainSlopeAtten;
half _RainMaskFrom;

half3 _RainReflectDirOffset;
half4 _RainFlowTilingOffset;
half _RainReflectIntensity;
half _RainFlowIntensity;

//----------------------------------------
half _CustomLightOn;
half4 _CustomLightDir;
half4 _CustomLightColor;
half _CustomLightColorUsage;

half _FresnelIntensity;

half _EnvIntensity;
half4 _ReflectDirOffset;
half4 _IBLCube_HDR;

//---------------------------------------- world emission
half _EmissionHeightOn;
half4 _EmissionHeight;
half4 _EmissionHeightColor;
half _EmissionHeightColorNormalAttenOn;

//---------------------------------------- storey
// half _StoreyTilingOn;
half4 _StoreyWindowInfo;
half _StoreyLightSwitchSpeed;
half _StoreyHeight;
// half _StoreyLineOn;
// half4 _StoreyLineColor;
half _StoreyLightOpaque;

//---------------------------------------- pbr details
half4 _DetailPBRMaskMap_ST;
half _DetailPBRMetallic;
half _DetailPBRSmoothness;
half _DetailPBROcclusion;

half _DetailWorldPlaneMode;
// half _DetailWorldPosTriplanar;

half _DetailPbrMaskApplyMetallic;
half _DetailPbrMaskApplySmoothness;
half _DetailPbrMaskApplyOcclusion;

CBUFFER_END

#endif //PBR_INPUT_HLSL