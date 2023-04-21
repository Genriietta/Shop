Shader "Unlit/glass"

{
    Properties {
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _Alpha ("Alpha", Range(0,1)) = 1
    }
 
    SubShader {
	//Queue Transparent
        Tags {"RenderType"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
	Zwrite Off

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv1 :TEXCOORD1;
            };
 
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 uv : TEXCOORD2;
                float3 worldLightDir : TEXCOORD3;
            };
 
            float4 _BaseColor;
            float _Alpha;
 
            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                //o.worldNormal = mul(unity_WorldToObject, float4(v.normal, 0)).xyz;
                //o.uv = v.vertex.xy * 0.5 + 0.5;
                o.uv.zw = (v.uv1 * unity_LightmapST.xy  + unity_LightmapST.zw);
                //o.worldLightDir = UnityWorldSpaceLightDir(o.worldPos);
                return o;
            }
 
            float4 frag (v2f i) : SV_Target {
                float3 lightmapColor = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv.zw ));;
                //float3 lightmapDir = UnityGetLightmapCoord(i.uv).zw;
                //float3 worldNormal = normalize(i.worldNormal);
                //float3 worldLightDir = normalize(i.worldLightDir);
                //float diffuse = max(0, dot(worldNormal, worldLightDir));
                float3 baseColor = _BaseColor.rgb;
                float3 lighting = baseColor;// *  lightmapColor;
                float4 finalColor = float4(lighting, _BaseColor.a * _Alpha);
                return finalColor;
            }
            ENDCG
        }
    }
 
    FallBack "Diffuse"
}