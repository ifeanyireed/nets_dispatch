"use client";

import { useState } from 'react';
import Map, { Marker } from 'react-map-gl/mapbox';
import 'mapbox-gl/dist/mapbox-gl.css';

const MAPBOX_TOKEN = process.env.NEXT_PUBLIC_MAPBOX_TOKEN || "pk.eyJ1IjoibmV0c2xvZ2lzdGljcyIsImEiOiJjbHhxNnZqMWQweHVtMmtxdGhjM2ZqcG5vIn0.PLACEHOLDER"; // Fallback to a placeholder or you must set it in .env.local

export default function LiveMapWidget() {
  const [viewState, setViewState] = useState({
    longitude: 3.3792, // Lagos coordinates
    latitude: 6.5244,
    zoom: 11
  });

  return (
    <div className="absolute inset-0 overflow-hidden">
      <Map
        {...viewState}
        onMove={evt => setViewState(evt.viewState)}
        mapStyle="mapbox://styles/mapbox/dark-v11"
        mapboxAccessToken={MAPBOX_TOKEN}
        attributionControl={false}
      >
        <Marker longitude={3.4211} latitude={6.4354} anchor="bottom">
          <div className="w-2.5 h-2.5 rounded-[50%_50%_50%_0] -rotate-45 bg-hazard shadow-[0_0_0_4px_rgba(245,166,35,0.2)]"></div>
        </Marker>
        <Marker longitude={3.332} latitude={6.59} anchor="bottom">
          <div className="w-2.5 h-2.5 rounded-[50%_50%_50%_0] -rotate-45 bg-sky shadow-[0_0_0_4px_rgba(58,169,240,0.2)]"></div>
        </Marker>
        <Marker longitude={3.37} latitude={6.48} anchor="bottom">
          <div className="w-2.5 h-2.5 rounded-[50%_50%_50%_0] -rotate-45 bg-live shadow-[0_0_0_4px_rgba(47,212,132,0.2)]"></div>
        </Marker>
      </Map>
      <div className="absolute bottom-3 left-3 px-3 py-1.5 bg-ink/80 backdrop-blur border border-hairline rounded-full flex items-center gap-2 pointer-events-none z-10">
        <div className="w-2 h-2 rounded-full bg-live animate-pulse shadow-[0_0_8px_rgba(47,212,132,0.6)]" />
        <span className="font-sans text-xs text-text-0 font-medium tracking-wide">Live Tracking Active</span>
      </div>
    </div>
  );
}
