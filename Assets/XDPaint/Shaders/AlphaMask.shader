Shader "XD Paint/Alpha Mask"
{
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _MaskTex ("Mask Texture", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcColorBlend ("__srcC", Int) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstColorBlend ("__dstC", Int) = 10
    }

    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane"}
        ZWrite Off
        ZTest On
        Blend [_SrcColorBlend] [_DstColorBlend]
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform sampler2D _MaskTex;
            uniform float4 _MaskTex_ST;

            struct app2vert
            {
                float4 position: POSITION;
                half4 color: COLOR;
                float2 texcoord: TEXCOORD0;
            };

            struct vert2frag
            {
                float4 position: SV_POSITION;
                half4 color: COLOR;
                float2 texcoord: TEXCOORD0;
            };

            vert2frag vert(app2vert input)
            {
                vert2frag output;
                output.position = UnityObjectToClipPos(input.position);
                output.color = input.color;
                output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);
                return output;
            }

            float4 frag(vert2frag input) : COLOR
            {
                float4 main_color = tex2D(_MainTex, input.texcoord);
                float4 mask_color = tex2D(_MaskTex, input.texcoord);
                float4 value = float4(main_color.r, main_color.g, main_color.b, main_color.a * mask_color.a) * input.color;
                return value;
            }
            ENDCG
        }
    }
}