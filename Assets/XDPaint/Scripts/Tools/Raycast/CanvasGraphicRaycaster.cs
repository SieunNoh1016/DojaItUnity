﻿using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System.Collections.Generic;

namespace XDPaint.Tools.Raycast
{
    [RequireComponent(typeof(GraphicRaycaster))]
    public class CanvasGraphicRaycaster : MonoBehaviour
    {
        private GraphicRaycaster raycaster;
        private EventSystem eventSystem;
        private PointerEventData pointerEventData;
        private List<RaycastResult> results;

        private const int ResultsCapacity = 64;

        void Start()
        {
            raycaster = GetComponent<GraphicRaycaster>();
            eventSystem = GetComponent<EventSystem>();
            if (eventSystem == null)
            {
#if UNITY_2023_1_OR_NEWER
                eventSystem = FindFirstObjectByType<EventSystem>();
#else
                eventSystem = FindObjectOfType<EventSystem>();
#endif
            }
            results = new List<RaycastResult>(ResultsCapacity);
        }

        public List<RaycastResult> GetRaycasts(Vector2 position)
        {
            if (raycaster == null)
                return null;
            
            pointerEventData = new PointerEventData(eventSystem) { position = position };
            results.Clear();
            results.Capacity = ResultsCapacity;
            raycaster.Raycast(pointerEventData, results);
            return results;
        }
    }
}