﻿Shader "XD Paint/Brush Sampler" 
{
    Properties
    {
        _MainTex ("Main", 2D) = "white" {}
        _BrushTex ("Brush", 2D) = "white" {}
        _BrushMaskTex ("Mask", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _BrushOffset ("Brush offset", Vector) = (0, 0, 0, 0)
    }
    
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane"}
        Cull Off Lighting Off ZTest Off ZWrite Off Fog { Color (0, 0, 0, 0) }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
 
            sampler2D _MainTex;
            uniform float4 _MainTex_TexelSize;
            uniform float4 _BrushTex_TexelSize;
            sampler2D _BrushMaskTex;
            float4 _BrushOffset;
            float4 _Color;

            float4 frag (v2f_img i) : SV_Target
            {
                float2 uv = float2(i.uv.x * _BrushOffset.z + _BrushOffset.x, i.uv.y * _BrushOffset.w + _BrushOffset.y);
                float4 color = tex2D(_MainTex, uv) * _Color;
                if (uv.x < 0.0f || uv.x > 1.0f || uv.y < 0.0f || uv.y > 1.0f)
                {
                    color = 0;
                }
                
                float4 mask = tex2D(_BrushMaskTex, i.uv);
                color.a *= mask.a;
                return color;
            }
            ENDCG
        }
    }
}