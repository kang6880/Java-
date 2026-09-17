/* =========================================================
   青甘大环线 · 自驾图鉴  视图层
   ========================================================= */

let uid = 0;
const U = () => 'g' + (++uid);
const $ = (s, el = document) => el.querySelector(s);
const $$ = (s, el = document) => Array.from(el.querySelectorAll(s));
const byId = id => SPOTS.find(s => s.id === id);

/* ---------------- 风景插画生成器（纯 SVG，离线可用） ---------------- */
function art(type) {
  const a = U(), b = U(), c = U();
  const common = `<rect width="400" height="225" fill="url(#${a})"/>`;
  switch (type) {
    case 'temple': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#BFD9F2"/><stop offset="1" stop-color="#EAF2F7"/></linearGradient></defs>
      ${common}
      <path d="M0 150 L60 118 L110 140 L170 108 L232 138 L300 112 L360 140 L400 122 L400 225 L0 225Z" fill="#CBD9CE"/>
      <path d="M0 178 Q100 160 200 176 T400 170 L400 225 L0 225Z" fill="#B4C6B8"/>
      <g transform="translate(150 96)">
        <rect x="0" y="52" width="100" height="46" fill="#8E3B2E"/>
        <path d="M-12 52 L50 26 L112 52 Z" fill="#C9A23C"/>
        <rect x="34" y="66" width="32" height="32" fill="#5E2A22"/>
        <rect x="6" y="60" width="12" height="14" fill="#E8DCC0"/><rect x="82" y="60" width="12" height="14" fill="#E8DCC0"/>
      </g>
      <g fill="#7B4A2C">
        <rect x="120" y="140" width="9" height="34"/><rect x="272" y="140" width="9" height="34"/>
      </g>
      <g><circle cx="129" cy="132" r="16" fill="#4F7A45"/><circle cx="281" cy="132" r="16" fill="#4F7A45"/></g>
      <g fill="#F2F2F2"><rect x="42" y="152" width="12" height="9" rx="2"/><rect x="352" y="152" width="12" height="9" rx="2"/></g>
      <path d="M0 196 Q200 186 400 196 L400 225 L0 225Z" fill="#A9BFAE"/>
    </svg>`;
    case 'lake': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#7FB6E8"/><stop offset="1" stop-color="#DDEEF9"/></linearGradient>
      <linearGradient id="${b}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#2E76C4"/><stop offset="1" stop-color="#69AEE0"/></linearGradient></defs>
      ${common}
      <circle cx="322" cy="52" r="24" fill="#FFF3D0" opacity=".95"/>
      <path d="M0 92 L52 66 L96 88 L142 62 L190 88 L238 70 L282 92 L400 74 L400 108 L0 108Z" fill="#9FB6C9" opacity=".7"/>
      <path d="M0 104 L60 84 L120 104 L186 86 L250 106 L316 90 L400 108 L400 118 L0 118Z" fill="#6E8FA8" opacity=".8"/>
      <rect y="118" width="400" height="52" fill="url(#${b})"/>
      <g stroke="#FFFFFF" stroke-opacity=".35" stroke-width="2">
        <path d="M20 134 H120"/><path d="M160 142 H280"/><path d="M300 130 H380"/><path d="M60 152 H190"/><path d="M230 158 H340"/>
      </g>
      <path d="M0 170 Q200 164 400 172 L400 225 L0 225Z" fill="#E3C74E"/>
      <path d="M0 186 Q200 178 400 188 L400 225 L0 225Z" fill="#D3B339"/>
      <g fill="#4B6B3A"><ellipse cx="30" cy="196" rx="16" ry="7"/><ellipse cx="352" cy="200" rx="18" ry="8"/></g>
    </svg>`;
    case 'salt': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#BEDCF2"/><stop offset="1" stop-color="#F3F7FA"/></linearGradient>
      <linearGradient id="${b}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#EAF4FA"/><stop offset="1" stop-color="#FFFFFF"/></linearGradient></defs>
      ${common}
      <circle cx="86" cy="46" r="20" fill="#FFF8E1" opacity=".9"/>
      <g opacity=".5" fill="#FFFFFF"><ellipse cx="300" cy="44" rx="46" ry="12"/><ellipse cx="336" cy="38" rx="30" ry="9"/></g>
      <rect y="96" width="400" height="129" fill="url(#${b})"/>
      <path d="M0 96 H400" stroke="#D7E6F0" stroke-width="2"/>
      <g stroke="#BFD8EA" stroke-width="2" stroke-opacity=".7">
        <path d="M30 126 H140"/><path d="M210 116 H330"/><path d="M60 156 H180"/><path d="M240 172 H360"/><path d="M100 196 H300"/>
      </g>
      <path d="M196 96 L204 96 L216 200 L188 200 Z" fill="#E3E9EE" opacity=".9"/>
      <g stroke="#C6D4DE" stroke-width="3"><path d="M196 96 V200"/><path d="M204 96 V200"/>
        <path d="M192 108 H208"/><path d="M191 130 H209"/><path d="M190 152 H210"/><path d="M189 174 H211"/></g>
      <g transform="translate(64 88)"><rect x="0" y="0" width="46" height="20" rx="5" fill="#C0513C"/>
        <rect x="4" y="-9" width="12" height="10" rx="2" fill="#8E3B2E"/><rect x="46" y="6" width="10" height="8" rx="2" fill="#8E3B2E"/>
        <circle cx="10" cy="14" r="3.5" fill="#3B3B3B"/><circle cx="34" cy="14" r="3.5" fill="#3B3B3B"/></g>
      <g fill="#8FA3B4"><path d="M300 200 l0-26 5 0 0 26z"/><path d="M296 176 h14 v4 h-14z"/></g>
      <g transform="translate(286 168)"><circle cx="0" cy="0" r="9" fill="#5C6B78"/>
        <path d="M0 -9 l3 5 h-6z" fill="#5C6B78"/><path d="M-9 4 l6-3 v6z" fill="#5C6B78"/></g>
    </svg>`;
    case 'grass': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#8FC4E8"/><stop offset="1" stop-color="#DCEBF5"/></linearGradient></defs>
      ${common}
      <path d="M0 96 L46 52 L82 84 L120 44 L164 86 L206 56 L252 90 L300 58 L348 92 L400 70 L400 104 L0 104Z" fill="#8EA6BC"/>
      <path d="M46 52 L60 71 L34 72 Z" fill="#FFFFFF"/><path d="M120 44 L136 66 L106 68 Z" fill="#FFFFFF"/>
      <path d="M252 90 L266 106 L238 108 Z" fill="#FFFFFF"/><path d="M348 92 L362 108 L334 110 Z" fill="#FFFFFF"/>
      <path d="M0 104 Q80 96 160 108 T400 100 L400 132 L0 132Z" fill="#3F6146"/>
      <path d="M0 128 Q100 118 200 130 T400 124 L400 148 L0 152Z" fill="#4E7449"/>
      <path d="M0 150 Q120 138 240 152 T400 146 L400 225 L0 225Z" fill="#6E9450"/>
      <path d="M120 225 Q150 176 210 168 Q268 162 296 200 Q300 216 292 225Z" fill="#89D3E0" opacity=".85"/>
      <g fill="#3A3A3A">
        <ellipse cx="86" cy="182" rx="13" ry="7"/><ellipse cx="94" cy="176" rx="7" ry="6"/>
        <ellipse cx="330" cy="196" rx="14" ry="8"/><ellipse cx="338" cy="189" rx="7" ry="6"/>
      </g>
      <g stroke="#4A6B39" stroke-width="2" opacity=".8">
        <path d="M60 200 v-9"/><path d="M276 166 v-8"/><path d="M356 214 v-8"/></g>
    </svg>`;
    case 'emerald': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#A9CBEA"/><stop offset="1" stop-color="#E9F1F8"/></linearGradient></defs>
      ${common}
      <path d="M0 84 L60 66 L120 82 L180 64 L240 82 L300 66 L360 84 L400 74 L400 96 L0 96Z" fill="#B9A38C" opacity=".65"/>
      <rect y="96" width="400" height="129" fill="#D9CEC0"/>
      <g>
        <path d="M18 116 L140 106 L176 118 L56 132Z" fill="#1F7FC4"/>
        <path d="M150 104 L268 96 L300 110 L182 122Z" fill="#2FA39A"/>
        <path d="M292 98 L392 96 L400 112 L306 116Z" fill="#E4D9BE"/>
        <path d="M28 138 L168 128 L200 142 L52 158Z" fill="#C9A64B"/>
        <path d="M182 130 L312 122 L340 138 L208 152Z" fill="#8FC8D8"/>
        <path d="M52 164 L216 154 L246 170 L74 190Z" fill="#2E9BD1"/>
        <path d="M226 156 L378 148 L400 172 L252 186Z" fill="#2C9C86"/>
      </g>
      <g stroke="#FFFFFF" stroke-opacity=".8" stroke-width="3" fill="none">
        <path d="M18 116 L176 118"/><path d="M150 104 L300 110"/><path d="M52 164 L246 170"/><path d="M28 138 L200 142"/>
      </g>
      <g stroke="#F4EFE6" stroke-width="2" opacity=".7">
        <path d="M182 122 L200 142"/><path d="M208 152 L246 170"/><path d="M306 116 L340 138"/></g>
      <g transform="translate(318 78)"><circle cx="0" cy="0" r="4" fill="#7C6A55"/><path d="M-6 4 h12 v3 h-12z" fill="#7C6A55"/></g>
    </svg>`;
    case 'road': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#9CC5EA"/><stop offset="1" stop-color="#E4EEF7"/></linearGradient></defs>
      ${common}
      <path d="M0 96 L54 70 L108 92 L166 68 L226 90 L282 70 L340 92 L400 74 L400 110 L0 110Z" fill="#A79277" opacity=".75"/>
      <path d="M0 110 Q120 100 240 112 T400 106 L400 225 L0 225Z" fill="#C7B195"/>
      <path d="M150 108 L188 108 L336 225 L36 225Z" fill="#5C5C5C"/>
      <path d="M166 108 L172 108 L230 225 L150 225Z" fill="#404040" opacity=".35"/>
      <g stroke="#F2E7CE" stroke-width="4" stroke-dasharray="14 16">
        <path d="M177 112 L196 182"/><path d="M177 200 L178 225"/>
      </g>
      <g fill="#8D7B62"><path d="M20 200 l4-16 4 16z"/><path d="M356 178 l4-16 4 16z"/></g>
      <g stroke="#8D7B62" stroke-width="2"><path d="M0 196 H60"/><path d="M340 184 H400"/></g>
    </svg>`;
    case 'spring': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><radialGradient id="${a}" cx="50%" cy="50%" r="60%">
        <stop offset="0" stop-color="#C98459"/><stop offset="1" stop-color="#A96C42"/></radialGradient>
      <radialGradient id="${b}" cx="50%" cy="50%" r="50%">
        <stop offset="0" stop-color="#3E9FC9"/><stop offset="1" stop-color="#8FD3D9"/></radialGradient></defs>
      <rect width="400" height="225" fill="url(#${a})"/>
      <g fill="none" stroke="#D9964F" stroke-opacity=".7">
        <circle cx="200" cy="112" r="82" stroke-width="10"/>
        <circle cx="200" cy="112" r="64" stroke-width="8"/>
        <circle cx="200" cy="112" r="48" stroke-width="7"/>
        <circle cx="200" cy="112" r="34" stroke-width="6"/>
      </g>
      <ellipse cx="200" cy="112" rx="30" ry="26" fill="url(#${b})"/>
      <ellipse cx="200" cy="110" rx="12" ry="10" fill="#DFF4F6" opacity=".8"/>
      <g stroke="#8C5A32" stroke-width="1.5" opacity=".5">
        <path d="M0 40 Q200 24 400 44"/><path d="M0 76 Q200 60 400 80"/><path d="M0 150 Q200 166 400 148"/><path d="M0 190 Q200 206 400 188"/>
      </g>
      <g fill="#F5EEE6" opacity=".55"><ellipse cx="60" cy="30" rx="24" ry="7"/><ellipse cx="340" cy="200" rx="26" ry="7"/></g>
    </svg>`;
    case 'ruin': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#C3B79C"/><stop offset="1" stop-color="#E8DFC9"/></linearGradient></defs>
      ${common}
      <path d="M0 100 L58 62 L104 92 L156 56 L216 90 L276 60 L336 94 L400 72 L400 112 L0 112Z" fill="#9A8E77" opacity=".8"/>
      <path d="M58 62 L70 78 L46 80Z" fill="#FFFFFF" opacity=".8"/><path d="M216 90 L228 106 L204 108Z" fill="#FFFFFF" opacity=".8"/>
      <path d="M0 110 Q200 100 400 112 L400 225 L0 225Z" fill="#D9CCAE"/>
      <g>
        <rect x="30" y="120" width="86" height="48" fill="#B9A98C"/>
        <rect x="30" y="120" width="86" height="8" fill="#9C8C6F"/>
        <g fill="#6E6350"><rect x="40" y="132" width="12" height="14"/><rect x="60" y="132" width="12" height="14"/><rect x="80" y="132" width="12" height="14"/>
          <rect x="40" y="152" width="12" height="12"/><rect x="80" y="152" width="12" height="12"/></g>
        <rect x="128" y="106" width="58" height="62" fill="#C3B394"/>
        <rect x="128" y="106" width="58" height="7" fill="#A3936F"/>
        <g fill="#6E6350"><rect x="136" y="118" width="13" height="16"/><rect x="158" y="118" width="13" height="16"/>
          <rect x="136" y="142" width="13" height="14"/></g>
        <rect x="196" y="126" width="70" height="42" fill="#AD9D80"/>
        <g fill="#6E6350"><rect x="206" y="138" width="12" height="14"/><rect x="228" y="138" width="12" height="14"/><rect x="248" y="138" width="10" height="14"/></g>
        <rect x="286" y="116" width="10" height="52" fill="#9A8A6D"/>
        <rect x="278" y="108" width="26" height="10" rx="2" fill="#8C7C60"/>
        <rect x="316" y="140" width="48" height="30" fill="#BAA98B"/>
        <g fill="#6E6350"><rect x="324" y="150" width="11" height="13"/><rect x="344" y="150" width="11" height="13"/></g>
      </g>
      <path d="M0 176 Q200 168 400 178 L400 225 L0 225Z" fill="#CBBB9A"/>
      <g stroke="#8C7C60" stroke-width="2"><path d="M370 108 v52"/><path d="M362 116 h16"/></g>
    </svg>`;
    case 'desert': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#F0C98A"/><stop offset="1" stop-color="#FBEBCB"/></linearGradient></defs>
      ${common}
      <circle cx="96" cy="60" r="26" fill="#FFF0C8" opacity=".9"/>
      <path d="M0 108 Q80 74 160 100 Q240 126 320 96 Q368 78 400 92 L400 225 L0 225Z" fill="#E8C489"/>
      <path d="M0 140 Q100 112 200 138 Q300 164 400 134 L400 225 L0 225Z" fill="#DFB872"/>
      <path d="M0 178 Q120 152 240 180 Q320 200 400 176 L400 225 L0 225Z" fill="#D3A75F"/>
      <path d="M120 108 Q150 88 180 108" stroke="#C79A5B" stroke-width="2" fill="none"/>
      <path d="M40 148 Q80 128 120 148" stroke="#C79A5B" stroke-width="2" fill="none"/>
      <g transform="translate(258 150)" fill="#8B6A3E">
        <path d="M0 18 l3-10 6 0 4 10 -3 0 0 8 -4 0 0-8z"/>
        <path d="M6 8 q-6-6 -2-10 q6 2 4 8"/>
        <path d="M30 20 l3-9 6 0 4 9 -3 0 0 7 -4 0 0-7z"/>
        <path d="M36 11 q-6-5 -2-9 q6 2 4 7"/>
      </g>
      <g stroke="#A9813F" stroke-width="2" opacity=".6" fill="none">
        <path d="M0 196 Q200 184 400 198"/>
      </g>
    </svg>`;
    case 'wall': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#BCD8EF"/><stop offset="1" stop-color="#EDF2F7"/></linearGradient></defs>
      ${common}
      <path d="M0 96 L60 58 L112 88 L166 54 L226 86 L286 58 L344 90 L400 68 L400 104 L0 104Z" fill="#8FA6BC"/>
      <path d="M60 58 L74 76 L46 78Z" fill="#FFFFFF"/><path d="M226 86 L240 102 L212 104Z" fill="#FFFFFF"/>
      <path d="M0 104 Q200 94 400 106 L400 225 L0 225Z" fill="#D8C8A6"/>
      <g transform="translate(70 70)">
        <rect x="0" y="44" width="180" height="66" fill="#A98D62"/>
        <rect x="0" y="44" width="180" height="7" fill="#8E7449"/>
        <g fill="#A98D62">
          <rect x="4" y="30" width="18" height="16"/><rect x="32" y="30" width="18" height="16"/><rect x="60" y="30" width="18" height="16"/>
          <rect x="88" y="30" width="18" height="16"/><rect x="116" y="30" width="18" height="16"/><rect x="144" y="30" width="18" height="16"/>
        </g>
        <rect x="54" y="82" width="40" height="28" fill="#6E5A3C"/>
        <path d="M46 82 L74 66 L102 82 Z" fill="#7E4B33"/>
        <rect x="120" y="50" width="44" height="32" fill="#B6986C"/>
        <path d="M114 50 L142 38 L170 50 Z" fill="#7E4B33"/>
        <g fill="#8E7449"><rect x="16" y="58" width="10" height="12"/><rect x="150" y="58" width="10" height="12"/></g>
      </g>
      <path d="M0 172 Q200 160 400 174 L400 225 L0 225Z" fill="#C9B48B"/>
      <g stroke="#8E7449" stroke-width="2" opacity=".7"><path d="M300 150 L400 130"/></g>
    </svg>`;
    case 'danxia': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#93BEE6"/><stop offset="1" stop-color="#E6EFF7"/></linearGradient></defs>
      ${common}
      <circle cx="330" cy="48" r="20" fill="#FFF1CE" opacity=".95"/>
      <g fill="#FFFFFF" opacity=".55"><ellipse cx="90" cy="42" rx="40" ry="10"/><ellipse cx="130" cy="36" rx="24" ry="7"/></g>
      <path d="M0 120 L70 78 L128 112 L188 74 L252 114 L318 82 L400 118 L400 225 L0 225Z" fill="#B8632F"/>
      <path d="M0 148 L74 108 L132 140 L196 104 L258 142 L322 112 L400 146 L400 225 L0 225Z" fill="#D98F3C"/>
      <path d="M0 176 L78 138 L140 170 L204 134 L266 172 L330 142 L400 174 L400 225 L0 225Z" fill="#E6BE6A"/>
      <path d="M0 202 L84 168 L146 196 L212 162 L274 198 L338 170 L400 200 L400 225 L0 225Z" fill="#9FB5A0"/>
      <g fill="none" stroke="#FFFFFF" stroke-opacity=".35" stroke-width="2">
        <path d="M0 132 Q70 96 128 122"/><path d="M188 88 Q252 124 318 96"/><path d="M0 192 Q146 154 274 190"/>
      </g>
      <path d="M0 214 Q200 206 400 216 L400 225 L0 225Z" fill="#8B7C63" opacity=".6"/>
    </svg>`;
    case 'flower': default: return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
      <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
        <stop offset="0" stop-color="#8CC0E8"/><stop offset="1" stop-color="#E0EDF7"/></linearGradient></defs>
      ${common}
      <path d="M0 96 L54 56 L98 88 L148 50 L196 86 L246 54 L296 88 L348 58 L400 84 L400 108 L0 108Z" fill="#8BA5B8"/>
      <path d="M54 56 L66 74 L42 76Z" fill="#FFFFFF"/><path d="M196 86 L208 102 L182 104Z" fill="#FFFFFF"/>
      <path d="M0 106 Q200 96 400 108 L400 132 L0 136Z" fill="#5C7C4B"/>
      <path d="M0 130 Q200 120 400 132 L400 158 L0 162Z" fill="#E2C33F"/>
      <path d="M0 156 Q200 146 400 158 L400 186 L0 190Z" fill="#EDD24E"/>
      <path d="M0 184 Q200 174 400 186 L400 225 L0 225Z" fill="#F5DF63"/>
      <g stroke="#C9A730" stroke-width="2" opacity=".6">
        <path d="M0 158 H400"/><path d="M0 186 H400"/>
      </g>
      <path d="M182 108 L188 108 L196 225 L166 225Z" fill="#C9BFA4" opacity=".9"/>
      <g fill="#FFFFFF" opacity=".8"><circle cx="70" cy="170" r="3"/><circle cx="120" cy="196" r="3"/><circle cx="300" cy="176" r="3"/><circle cx="352" cy="204" r="3"/></g>
    </svg>`;
  }
}

/* ---------------- 环线地图 ---------------- */
function routeMap() {
  const N = Object.fromEntries(MAP_NODES.map(n => [n.id, n]));
  const pts = MAP_PATH.map(id => `${N[id].x},${N[id].y}`).join(' ');
  const branch = MAP_BRANCH.map(([a, b]) => `<line x1="${N[a].x}" y1="${N[a].y}" x2="${N[b].x}" y2="${N[b].y}"
      stroke="#C98A2E" stroke-width="2" stroke-dasharray="6 6" opacity=".85"/>`).join('');
  const nodes = MAP_NODES.map(n => {
    const lx = n.side === 'l' ? n.x - 12 : n.side === 'r' ? n.x + 12 : n.x;
    const ly = n.side === 't' ? n.y - 12 : n.side === 'b' ? n.y + 18 : n.y + 4;
    const anchor = n.side === 'l' ? 'end' : n.side === 'r' ? 'start' : 'middle';
    return `<g class="map-node" data-id="${n.id}">
      <circle cx="${n.x}" cy="${n.y}" r="14" fill="#FFFFFF" opacity=".01"/>
      <circle cx="${n.x}" cy="${n.y}" r="6.5" fill="#FFFFFF" stroke="#2F80ED" stroke-width="3"/>
      <text class="map-label" x="${lx}" y="${ly}" text-anchor="${anchor}">${n.label}</text>
    </g>`;
  }).join('');
  return `<svg viewBox="0 0 720 420" role="img" aria-label="青甘大环线示意地图">
    <defs>
      <linearGradient id="bgPaper" x1="0" y1="0" x2="1" y2="1">
        <stop offset="0" stop-color="#FBF7F0"/><stop offset="1" stop-color="#F2EADC"/></linearGradient>
    </defs>
    <rect width="720" height="420" rx="10" fill="url(#bgPaper)"/>
    <path d="M470 250 q60-70 150-60 q70 8 100-40 l0-160 -700 0 0 420 700 0 z" fill="#EDF2EC" opacity=".7"/>
    <path d="M20 300 q120-90 300-60 q160 26 250-10 l150-30 0 220 -700 0 z" fill="#F6EFE0" opacity=".8"/>
    <ellipse cx="520" cy="372" rx="72" ry="30" fill="#BBD9F0" opacity=".85"/>
    <text x="520" y="368" text-anchor="middle" font-size="13" fill="#2E6CA8" opacity=".8">青海湖</text>
    <ellipse cx="380" cy="372" rx="30" ry="14" fill="#E6EEF5" opacity=".9"/>
    <polyline points="${pts}" fill="none" stroke="#2F80ED" stroke-width="3.2" stroke-linejoin="round" stroke-linecap="round"/>
    ${branch}
    ${nodes}
    <text x="352" y="416" text-anchor="middle" font-size="11" fill="#7A8894">示意地图 · 非精确地理比例</text>
  </svg>`;
}

/* ---------------- 卡片 ---------------- */
function card(s) {
  const inWish = wishList().includes(s.id);
  return `<article class="card" data-id="${s.id}">
    <div class="card-art">${art(s.scene)}<span class="card-day">${s.day}</span></div>
    <div class="card-body">
      <h3>${s.name}</h3>
      <div class="loc">${s.region} · ${s.en}</div>
      <div class="tagrow">${s.tags.slice(0, 3).map(t => `<span class="tag">${t}</span>`).join('')}</div>
      <p class="desc">${s.tagline}</p>
      <div class="card-foot">
        <span class="price">门票参考 <b>${s.meta['门票']}</b></span>
        <button class="wish-btn ${inWish ? 'on' : ''}" data-wish="${s.id}">${inWish ? '已加入' : '+ 清单'}</button>
      </div>
    </div>
  </article>`;
}

/* ---------------- 视图：总览 ---------------- */
function viewHome() {
  const total = SPOTS.reduce((n, s) => n + s.photoSpots.length, 0);
  const foods = SPOTS.reduce((n, s) => n + s.foods.length, 0);
  const beds = SPOTS.reduce((n, s) => n + s.stays.length, 0);
  return `
  <div class="wrap">
    <section class="hero">
      <div class="hero-grid">
        <div class="hero-copy">
          <span class="eyebrow">Qinghai · Gansu Loop</span>
          <h1>把 <em>青海湖的蓝</em>、柴达木的彩池<br>和河西走廊的风，串成一条线</h1>
          <p class="lead">13 个站点，逐站拆解：怎么玩、在哪拍、吃什么、住哪划算。全部内容离线可用，路上没信号也能翻。</p>
          <div class="hero-cta">
            <a class="btn" href="#/atlas">进入景点图鉴 →</a>
            <a class="btn alt" href="#/route">查看 12 天行程</a>
          </div>
          <div class="hero-stats">
            <div><strong>${SPOTS.length}</strong><span>站点</span></div>
            <div><strong>${total}</strong><span>打卡机位</span></div>
            <div><strong>${foods}</strong><span>特色美食</span></div>
            <div><strong>${beds}</strong><span>住宿选项</span></div>
          </div>
        </div>
        <div class="hero-art">${art('emerald')}</div>
      </div>
    </section>

    <section class="section">
      <div class="note warn">
        <b>${ALERT.title}</b><br>
        <span class="muted">封闭期：${ALERT.period}</span>
        <ul style="margin-top:10px">${ALERT.lines.map(l => `<li>· ${l}</li>`).join('')}</ul>
        <ul style="margin-top:8px">${ALERT.tips.map(l => `<li>✔ ${l}</li>`).join('')}</ul>
      </div>
    </section>

    <section class="section">
      <div class="sec-head"><div><span class="eyebrow">Route Map</span><h2>环线走向</h2></div>
        <div class="sub">点击地图上的圆点，直接进入该站详情</div></div>
      <div class="mapbox">${routeMap()}
        <div class="map-legend">
          <span><i style="background:#2F80ED"></i>主线全程</span>
          <span><i style="background:#C98A2E"></i>深度支线（茫崖）</span>
          <span>自驾约 3200 km · 建议 10—12 天</span>
        </div>
      </div>
    </section>

    <section class="section">
      <div class="sec-head"><div><span class="eyebrow">Popular</span><h2>必看六站</h2></div>
        <a class="link-more" href="#/atlas">看全部 ${SPOTS.length} 站 →</a></div>
      <div class="grid cards-3">
        ${['qinghaihu', 'chaka', 'dachaidan', 'dunhuang', 'zhangye', 'qilian'].map(id => card(byId(id))).join('')}
      </div>
    </section>

    <section class="section">
      <div class="grid cards-2">
        <div class="panel">
          <h3>为什么是 12 天</h3>
          <p>全线约 3200 km，若少于 9 天会有大量时间在赶路。12 天能在青海湖、翡翠湖、敦煌、丹霞、祁连各留足时段，还能塞进茫崖支线 — 这是“不后悔”和“到此一游”的分界线。<br>
          只有 9 天？看 <a href="#/route/compact" style="color:var(--lake-d);font-weight:600">压缩版行程</a>（异地还车 + 放弃回归段），页面底部还有「茫崖支线决策器」帮你取舍。</p>
        </div>
        <div class="panel">
          <h3>三条硬性提醒</h3>
          <p>① 莫高窟 A 类票必须提前 30 天早上 7:00 抢；② G227 扁都口—峨堡段 2026-09-01 起封闭到 2027-06-30，绕行走 S302 + G213；③ U 型公路拍照严禁站路面，近年已发生多起伤亡事故。</p>
        </div>
      </div>
    </section>
  </div>`;
}

/* ---------------- 视图：图鉴 ---------------- */
function viewAtlas() {
  const regions = ['全部', ...Array.from(new Set(SPOTS.map(s => s.region)))];
  return `
  <div class="wrap">
    <div class="sec-head"><div><span class="eyebrow">Atlas</span><h2>景点图鉴 · ${SPOTS.length} 站</h2></div>
      <div class="sub">点任意卡片，展开该站的风景看点 / 打卡机位 / 特色美食 / 性价比住宿</div></div>
    <div class="chips" id="chips">${regions.map((r, i) => `<button class="chip ${i === 0 ? 'active' : ''}" data-region="${r}">${r}</button>`).join('')}</div>
    <div class="result-bar" id="resultBar">共 ${SPOTS.length} 站</div>
    <div class="grid cards-3" id="atlasGrid">${SPOTS.map(card).join('')}</div>
  </div>`;
}

/* ---------------- 视图：行程 ---------------- */
function viewRoute(mode) {
  const is9 = mode === 'compact';
  const days = is9 ? DAYS_9 : DAYS;
  const sw = `<div class="chips" id="routeSwitch">
      <button class="chip ${!is9 ? 'active' : ''}" data-route="12">12 天经典环线（往返西宁）</button>
      <button class="chip ${is9 ? 'active' : ''}" data-route="9">9 天压缩版（异地还车）</button>
    </div>`;
  return `
  <div class="wrap">
    <div class="sec-head"><div><span class="eyebrow">Itinerary</span><h2>${is9 ? '9 天压缩行程' : '12 天自驾行程'}</h2></div>
      <div class="sub">橙色标记为可选支线，时间紧可直接跳过</div></div>
    ${sw}
    <div class="note ok"><b>行程说明：</b>${is9
      ? '以“西宁取车 — 张掖/机场异地还车”为准，绕过封路回归段。日均车程较 12 天版更长，D6 是全程最赶的一天，请务必 8:30 前出发。'
      : '以“西宁取车 — 西宁还车”为准，日均车程控制在 4 小时内；D6 茫崖支线需四驱越野，放弃则全天可在水上雅丹—大柴旦之间休整。'}</div>

    ${is9 ? `<section class="section"><div class="note warm">
      <b>${COMPACT_NOTE.title}</b>
      <ul style="margin-top:10px">${COMPACT_NOTE.items.map(i => `<li>· ${i}</li>`).join('')}</ul>
      <ul style="margin-top:8px">${COMPACT_NOTE.keep.map(i => `<li>✔ ${i}</li>`).join('')}</ul>
    </div></section>` : ''}

    <section class="section">
      <div class="timeline">
        ${days.map(d => `
          <div class="tl-item ${d.open ? 'deep' : ''}">
            <div class="tl-card">
              <div class="tl-top">
                <span class="tl-day">${d.d}</span>
                <span class="tl-title">${d.t}</span>
                <span class="tl-km">${d.km}</span>
              </div>
              <div class="tl-route">🚗 ${d.rt}</div>
              <ul class="tl-list">${d.li.map(i => `<li>${i}</li>`).join('')}</ul>
              <span class="tl-night">🏨 ${d.night}</span>
            </div>
          </div>`).join('')}
      </div>
    </section>

    ${viewDecision('mangyaDecision')}
  </div>`;
}

/* ---------------- 茫崖支线决策器 ---------------- */
const quizState = {};
function quizCalc() {
  const ans = MANGYA_QUIZ.qs.map((_, i) => quizState[i]);
  const score = ans.reduce((n, v) => n + (v === 1 ? 1 : 0), 0);
  const pending = ans.filter(v => v === undefined).length;
  const v = MANGYA_QUIZ.verdicts.find(x => score >= x.min);
  return { score, pending, v };
}
function verdictInner() {
  const { score, pending, v } = quizCalc();
  return `<div class="v-head">${pending ? `已答 ${MANGYA_QUIZ.qs.length - pending}/${MANGYA_QUIZ.qs.length} 题 · 当前得分 ${score}` : `你的得分：${score} / 4`}</div>
      <div class="v-lv">${pending ? '继续作答以得出结论' : v.lv}</div>
      <p>${pending ? '结论会在 4 题全部作答后给出。' : v.text}</p>`;
}
function decisionHTML() {
  const { v } = quizCalc();
  return `<div class="sec-head"><div><span class="eyebrow">Decision</span><h2>支线取舍：茫崖到底去不去</h2></div>
      <div class="sub">4 个问题，答完自动给结论</div></div>
    <div class="mapbox">
      <p style="font-size:14px;color:var(--ink-2);margin-bottom:18px">${MANGYA_QUIZ.intro}</p>
      <div class="quiz">
        ${MANGYA_QUIZ.qs.map((item, i) => `
          <div class="quiz-q">
            <div class="qq-title"><b>Q${i + 1}</b> ${item.q}</div>
            <div class="quiz-opts">
              <button class="qbtn yes ${quizState[i] === 1 ? 'on' : ''}" data-q="${i}" data-v="1">能满足</button>
              <button class="qbtn no ${quizState[i] === 0 ? 'on' : ''}" data-q="${i}" data-v="0">不满足 / 不确定</button>
            </div>
            <div class="qq-why">💡 ${item.why}</div>
          </div>`).join('')}
      </div>
      <div class="verdict ${v.color}" id="quizVerdict" style="margin-top:18px">${verdictInner()}</div>
      <div class="sub" style="margin-top:16px">不想去茫崖时，这两天更好的去向：</div>
      <ul class="tl-list" style="margin-top:8px">${MANGYA_QUIZ.alt.map(a => `<li>${a}</li>`).join('')}</ul>
    </div>`;
}
const viewDecision = () => `<section class="section" id="mangyaDecision">${decisionHTML()}</section>`;

/* ---------------- 视图：出行准备 ---------------- */
function viewPrep() {
  const sum = BUDGET.reduce((n, b) => n + Number(b.v), 0);
  return `
  <div class="wrap">
    <div class="sec-head"><div><span class="eyebrow">Preparation</span><h2>出行准备</h2></div>
      <div class="sub">抢票时间线 · 装备清单 · 自驾合规 · 预算测算</div></div>

    <div class="note warn"><b>三条最容易翻车的事：</b>莫高窟没抢到票 / G227 走到封路路段 / 大柴旦与黑马河旺季无房。请在出发前逐条确认。</div>

    <section class="section">
      <h3 style="font-size:19px;margin-bottom:12px">门票与抢票时间线</h3>
      <div class="panel" style="padding:0;overflow:hidden">
        <table class="tbl">
          <thead><tr><th style="width:20%">项目</th><th style="width:26%">时间节点</th><th style="width:24%">渠道</th><th>备注</th></tr></thead>
          <tbody>${BOOKING.map(b => `<tr><td><b>${b.item}</b></td><td>${b.when}</td><td>${b.where}</td><td class="muted">${b.note}</td></tr>`).join('')}</tbody>
        </table>
      </div>
    </section>

    <section class="section">
      <h3 style="font-size:19px;margin-bottom:12px">装备清单</h3>
      <div class="grid cards-3">
        ${GEAR.map(g => `<div class="panel">
          <h3>${g.t}</h3>
          <ul class="tl-list">${g.i.map(i => `<li>${i}</li>`).join('')}</ul>
        </div>`).join('')}
      </div>
    </section>

    <section class="section">
      <h3 style="font-size:19px;margin-bottom:12px">自驾与合规要点</h3>
      <div class="grid cards-2">
        ${DRIVE.map(d => `<div class="panel"><h3>${d.t}</h3><p>${d.d}</p></div>`).join('')}
      </div>
    </section>

    <section class="section">
      <h3 style="font-size:19px;margin-bottom:12px">预算参考（2 人自驾 · 12 天）</h3>
      <div class="panel" style="padding:0;overflow:hidden">
        <table class="tbl">
          <thead><tr><th>项目</th><th style="width:16%">金额（元）</th><th>说明</th></tr></thead>
          <tbody>
            ${BUDGET.map(b => `<tr><td><b>${b.k}</b></td><td class="num">${Number(b.v).toLocaleString()}</td><td class="muted">${b.note}</td></tr>`).join('')}
            <tr><td><b>合计</b></td><td class="num"><b>${sum.toLocaleString()}</b></td><td class="muted">人均约 ${Math.round(sum / 2).toLocaleString()} 元（旺季中端标准）</td></tr>
          </tbody>
        </table>
      </div>
      <div class="note" style="margin-top:14px">预算不含往返大交通（机票/高铁）。若压缩到 9 天 2 人，可省约 2 天租车油费 + 2 晚住宿，约合 1800—2500 元。</div>
    </section>
  </div>`;
}

/* ---------------- 详情页 ---------------- */
function detailHTML(s) {
  const idx = SPOTS.indexOf(s);
  const prev = SPOTS[(idx - 1 + SPOTS.length) % SPOTS.length];
  const next = SPOTS[(idx + 1) % SPOTS.length];
  const inWish = wishList().includes(s.id);
  return `
  <div class="dt-hero">
    ${art(s.scene)}
    <div class="dt-title"><h2>${s.name}</h2><span>${s.region} · ${s.en} · 行程 ${s.day}</span></div>
  </div>
  <div class="dt-inner">
    <div class="dt-meta">
      ${Object.entries(s.meta).map(([k, v]) => `<div><dl><dt>${k}</dt><dd>${v}</dd></dl></div>`).join('')}
    </div>
    <p style="font-size:14.5px;color:var(--ink-2);margin-bottom:18px">${s.intro.join('<br><br>')}</p>
    <div class="switch-row" style="margin-bottom:26px">
      <button class="wish-btn ${inWish ? 'on' : ''}" style="padding:9px 16px;font-size:13px" data-wish="${s.id}">${inWish ? '✓ 已在打卡清单' : '+ 加入打卡清单'}</button>
      <button class="wish-btn" style="padding:9px 16px;font-size:13px" id="copySpot">复制本站速查</button>
    </div>

    <div class="dt-nav">
      <a href="javascript:void(0)" data-anchor="blk-view">风景看点</a>
      <a href="javascript:void(0)" data-anchor="blk-photo">打卡机位 ${s.photoSpots.length}</a>
      <a href="javascript:void(0)" data-anchor="blk-food">特色美食 ${s.foods.length}</a>
      <a href="javascript:void(0)" data-anchor="blk-bed">性价比住宿 ${s.stays.length}</a>
      <a href="javascript:void(0)" data-anchor="blk-tip">实用贴士</a>
    </div>

    <div class="blk" id="blk-view">
      <h3>风景看点</h3><div class="hint">这一站最值得把时间花在哪</div>
      <ul class="numlist">${s.highlights.map((h, i) => `<li><span class="idx">${i + 1}</span><div><h4>${h.t}</h4><p>${h.d}</p></div></li>`).join('')}</ul>
    </div>

    <div class="blk" id="blk-photo">
      <h3>打卡机位</h3><div class="hint">机位位置 · 最佳时间 · 器材与拍摄建议</div>
      <ul class="numlist">${s.photoSpots.map((p, i) => `<li><span class="idx">${i + 1}</span>
        <div><h4>${p.n}</h4><p>${p.p}</p>
        <div class="kv"><span class="k">⏰ ${p.time}</span><span>📷 ${p.g}</span></div></div></li>`).join('')}</ul>
    </div>

    <div class="blk food" id="blk-food">
      <h3>特色美食</h3><div class="hint">括号内为参考人均价格</div>
      <div class="food-grid">${s.foods.map(f => `<div class="food-item">
        <div class="top"><h4>${f.n}</h4><span class="price">${f.p}</span></div>
        <p>${f.d}</p><div class="where">📍 ${f.w}</div></div>`).join('')}</div>
    </div>

    <div class="blk bed" id="blk-bed">
      <h3>性价比住宿</h3><div class="hint">按“价格 / 位置 / 条件”三维给出建议，均为参考价</div>
      <div class="bed-list">${s.stays.map(st => `<div class="bed-item">
        <div class="top"><h4>${st.n}</h4><span class="price">${st.p}</span><span class="lv">${st.lv}</span></div>
        <p>${st.d}</p>
        <div class="cond">
          <span class="good"><b>优势：</b>${st.good}</span>
          <span class="bad"><b>短板：</b>${st.bad}</span>
        </div></div>`).join('')}</div>
    </div>

    <div class="blk tip" id="blk-tip">
      <h3>实用贴士</h3><div class="hint">前人踩过的坑，能省就是省</div>
      <ul class="numlist">${s.tips.map((t, i) => `<li><span class="idx">${i + 1}</span><div><p>${t}</p></div></li>`).join('')}</ul>
    </div>

    <div class="switch-row" style="border-top:1px dashed var(--line);padding-top:18px">
      <button class="btn alt" data-goto="${prev.id}">← ${prev.name}</button>
      <button class="btn alt" data-goto="${next.id}">${next.name} →</button>
    </div>
  </div>`;
}

/* ---------------- 清单 ---------------- */
const WKEY = 'qg_wish_v1';
const wishList = () => { try { return JSON.parse(localStorage.getItem(WKEY)) || []; } catch (e) { return []; } };
const setWish = arr => { localStorage.setItem(WKEY, JSON.stringify(arr)); };
function renderWishCount() { $('#wishCount').textContent = wishList().length; }
function renderWish() {
  const list = wishList();
  const rows = list.map(id => {
    const s = byId(id);
    if (!s) return '';
    return `<div class="wish-item"><span class="n">${s.name} <span class="muted" style="font-size:12px">· ${s.day}</span></span>
      <button class="wish-del" data-wish="${id}" title="移除">✕</button></div>`;
  }).join('');
  $('#wishBody').innerHTML = `<div class="wish-body">
    <h3>我的打卡清单 <span class="muted" style="font-size:14px">${list.length} 站</span></h3>
    <p class="muted" style="font-size:13px">用于行前核对，清单保存在本机浏览器中。</p>
    ${rows || '<p class="muted" style="margin-top:16px">还没有添加。在任意景点卡片或详情页点击「+ 清单」即可。</p>'}
    <div class="switch-row">
      <button class="btn" id="copyWish">复制为文字清单</button>
      <button class="btn alt" id="clearWish">清空</button>
      <button class="btn alt" id="printWish">打印</button>
    </div>
  </div>`;
}
function toast(msg) {
  let t = $('.copytoast');
  if (!t) { t = document.createElement('div'); t.className = 'copytoast'; document.body.appendChild(t); }
  t.textContent = msg; t.classList.add('show');
  clearTimeout(t._tm); t._tm = setTimeout(() => t.classList.remove('show'), 1900);
}
function copy(text, okMsg) {
  const done = () => toast(okMsg || '已复制');
  if (navigator.clipboard && window.isSecureContext) navigator.clipboard.writeText(text).then(done, fb);
  else fb();
  function fb() {
    const ta = document.createElement('textarea'); ta.value = text; ta.style.position = 'fixed'; ta.style.opacity = '0';
    document.body.appendChild(ta); ta.select();
    try { document.execCommand('copy'); done(); } catch (e) { toast('复制失败，请手动选择'); }
    ta.remove();
  }
}

/* ---------------- 抽屉 ---------------- */
function openDrawer(el, content) {
  const body = el.querySelector('.drawer-body');
  if (body) body.innerHTML = content; else el.innerHTML = content; // 保留遮罩与关闭按钮
  el.classList.add('open');
  el.setAttribute('aria-hidden', 'false');
  document.body.style.overflow = 'hidden';
}
function closeDrawer(el) {
  el.classList.remove('open');
  el.setAttribute('aria-hidden', 'true');
  document.body.style.overflow = '';
}
function showSpot(id) {
  const s = byId(id);
  if (!s) return;
  openDrawer($('#drawer'), detailHTML(s));
  $('#drawer .drawer-panel').scrollTop = 0;
  if (location.hash !== '#/atlas/' + id) history.replaceState(null, '', '#/atlas/' + id);
}

/* ---------------- 路由 ---------------- */
function render() {
  const h = location.hash || '#/home';
  const m = h.match(/^#\/(home|atlas|route|prep)(?:\/([\w-]+))?$/);
  const tab = m ? m[1] : 'home';
  $$('#nav a').forEach(a => a.classList.toggle('active', a.dataset.tab === tab));
  const app = $('#app');
  if (tab === 'home') app.innerHTML = viewHome();
  else if (tab === 'atlas') app.innerHTML = viewAtlas();
  else if (tab === 'route') app.innerHTML = viewRoute(m && m[2] === 'compact' ? 'compact' : 'full');
  else app.innerHTML = viewPrep();
  window.scrollTo(0, 0);

  if (m && m[2] && tab === 'atlas') showSpot(m[2]);
  // 地图节点
  $$('.map-node').forEach(g => g.addEventListener('click', () => showSpot(g.dataset.id)));
  // 筛选
  $$('#chips .chip').forEach(c => c.addEventListener('click', () => {
    $$('#chips .chip').forEach(x => x.classList.remove('active'));
    c.classList.add('active');
    const r = c.dataset.region;
    const shown = SPOTS.filter(s => r === '全部' || s.region === r);
    $('#atlasGrid').innerHTML = shown.map(card).join('');
    $('#resultBar').textContent = r === '全部' ? `共 ${SPOTS.length} 站` : `${r}：共 ${shown.length} 站`;
  }));
}

/* ---------------- 搜索 ---------------- */
function doSearch(q) {
  q = q.trim().toLowerCase();
  if (!q) { history.replaceState(null, '', '#/atlas'); render(); return; }
  history.replaceState(null, '', '#/atlas'); // 用 replaceState 避免 hashchange 二次渲染冲掉结果
  render();
  const hit = SPOTS.filter(s => {
    const hay = [s.name, s.en, s.region, s.tagline, s.desc, s.tags.join(','),
      s.highlights.map(h => h.t + h.d).join(','), s.photoSpots.map(p => p.n + p.p + p.g).join(','),
      s.foods.map(f => f.n + f.d + f.w).join(','), s.stays.map(t => t.n + t.d).join(','),
      s.tips.join(',')].join(',').toLowerCase();
    return hay.includes(q);
  });
  $('#atlasGrid').innerHTML = hit.length
    ? hit.map(card).join('')
    : `<p style="grid-column:1/-1" class="muted">没有匹配「${q}」的结果，试试“日出”“牛肉面”“机位”“住宿”。</p>`;
  $('#resultBar').textContent = `搜索「${q}」：命中 ${hit.length} 站`;
  $$('#chips .chip').forEach(x => x.classList.remove('active'));
}

/* ---------------- 事件委托 ---------------- */
document.addEventListener('click', e => {
  const t = e.target;
  if (t.closest('[data-close]')) {
    $$('.drawer').forEach(d => closeDrawer(d));
    return;
  }
  if (t.closest('#wishBtn')) {
    renderWish();
    $('#wishDrawer').classList.add('open');
    $('#wishDrawer').setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
    return;
  }
  const wish = t.closest('[data-wish]');
  if (wish) {
    e.stopPropagation();
    const id = wish.dataset.wish;
    const arr = wishList();
    const i = arr.indexOf(id);
    const added = i < 0;
    added ? arr.push(id) : arr.splice(i, 1);
    setWish(arr);
    renderWishCount();
    toast(added ? '已加入打卡清单' : '已从清单移除');
    $$(`[data-wish="${id}"]`).forEach(b => {
      const inCard = !!b.closest('.card');
      b.classList.toggle('on', added);
      if (inCard) b.textContent = added ? '已加入' : '+ 清单';
      else if (b.textContent.indexOf('清单') >= 0) b.textContent = added ? '✓ 已在打卡清单' : '+ 加入打卡清单';
    });
    if ($('#wishDrawer').classList.contains('open')) renderWish();
    return;
  }
  const gotoEl = t.closest('[data-goto]');
  if (gotoEl) { showSpot(gotoEl.dataset.goto); return; }
  const rsw = t.closest('[data-route]');
  if (rsw) { location.hash = rsw.dataset.route === '9' ? '#/route/compact' : '#/route'; return; }
  const qb = t.closest('[data-q]');
  if (qb) {
    const i = qb.dataset.q, val = Number(qb.dataset.v);
    quizState[i] = val;
    $$(`[data-q="${i}"]`).forEach(b => b.classList.toggle('on', Number(b.dataset.v) === val));
    const box = $('#quizVerdict');
    box.className = 'verdict ' + quizCalc().v.color;
    box.style.marginTop = '18px';
    box.innerHTML = verdictInner();
    return;
  }
  const anchor = t.closest('[data-anchor]');
  if (anchor) { $(`#${anchor.dataset.anchor}`).scrollIntoView({ behavior: 'smooth' }); return; }
  const art = t.closest('.card');
  if (art) { showSpot(art.dataset.id); return; }
  if (t.closest('#copySpot')) {
    const s = byId(location.hash.split('/')[2]);
    if (s) copy(`${s.name}\n${s.tagline}\n\n【机位】\n${s.photoSpots.map((p, i) => `${i + 1}. ${p.n} — ${p.time}｜${p.g}`).join('\n')}\n\n【美食】\n${s.foods.map(f => `- ${f.n} (${f.p}) ${f.d}`).join('\n')}\n\n【住宿】\n${s.stays.map(st => `- ${st.n} ${st.p}｜优势 ${st.good}｜短板 ${st.bad}`).join('\n')}`, '已复制本站速查');
    return;
  }
  if (t.closest('#copyWish')) {
    const list = wishList().map(id => byId(id)).filter(Boolean);
    copy('青甘大环线 · 我的打卡清单\n' + list.map((s, i) => `${i + 1}. ${s.name}（${s.day}）— ${s.tagline}`).join('\n'), '已复制清单');
    return;
  }
  if (t.closest('#clearWish')) { setWish([]); renderWishCount(); renderWish(); toast('已清空'); return; }
  if (t.closest('#printWish')) { window.print(); return; }
});

let searchTimer;
$('#search').addEventListener('input', e => {
  clearTimeout(searchTimer);
  const v = e.target.value;
  searchTimer = setTimeout(() => doSearch(v), 220);
});
$('#search').addEventListener('keydown', e => { if (e.key === 'Enter') doSearch(e.target.value); });

document.addEventListener('keydown', e => {
  if (e.key === 'Escape') $$('.drawer').forEach(d => closeDrawer(d));
});
window.addEventListener('hashchange', () => {
  const m = location.hash.match(/^#\/atlas\/([\w-]+)$/);
  if (m) { showSpot(m[1]); return; }
  if (!location.hash.startsWith('#/atlas/')) $$('.drawer').forEach(d => closeDrawer(d));
  render();
});

renderWishCount();
render();
