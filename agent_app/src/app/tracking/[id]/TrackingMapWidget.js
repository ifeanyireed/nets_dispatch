"use client";

import { useState } from 'react';
import Map, { Marker } from 'react-map-gl/mapbox';
import 'mapbox-gl/dist/mapbox-gl.css';

const MAPBOX_TOKEN = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || "pk.eyJ1IjoiMTBteXR0b2ZmaWNpYWwiLCJhIjoiY21kdXhjdWFpMHRzdTJscXloaWx5NWk5YyJ9.nsfMQdeupgK-YSfD2y-JjQ";

export default function TrackingMapWidget() {
  const [viewState, setViewState] = useState({
    longitude: 3.3792,
    latitude: 6.5244,
    zoom: 12
  });

  return (
    <div className="absolute inset-0 overflow-hidden rounded-xl">
      <Map
        {...viewState}
        onMove={evt => setViewState(evt.viewState)}
        mapStyle="mapbox://styles/mapbox/dark-v11"
        mapboxAccessToken={MAPBOX_TOKEN}
        attributionControl={false}
      >
        {/* Rider Marker */}
        <Marker longitude={3.3792} latitude={6.5244} anchor="bottom">
          <div className="relative flex items-center justify-center">
            <div className="absolute w-8 h-8 bg-hazard/20 rounded-full animate-ping" />
            <div className="w-4 h-4 rounded-full bg-hazard border-2 border-white shadow-[0_0_10px_rgba(255,42,42,0.6)]" />
          </div>
        </Marker>
      </Map>
      <div className="absolute bottom-3 left-3 px-3 py-1.5 bg-ink/80 backdrop-blur border border-white/5 rounded-full flex items-center gap-2 pointer-events-none z-10">
        <div className="w-2 h-2 rounded-full bg-hazard animate-pulse shadow-[0_0_8px_rgba(255,42,42,0.6)]" />
        <span className="font-sans text-[10px] text-white font-bold tracking-[1px] uppercase">Live Rider Location</span>
      </div>
    </div>
  );
}
