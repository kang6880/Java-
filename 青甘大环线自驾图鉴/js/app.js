/* =========================================================
   青甘大环线 · 自驾图鉴  —— Vue 3 重写版（视图层）
   数据来自 data.js（全局常量 ALERT / SPOTS / DAYS ...）
   SVG 插画 art() / routeMap() 复用自原 app.js
   ========================================================= */
(function () {
  'use strict';
  const { createApp, ref, reactive, computed, watch, nextTick, onMounted } = Vue;

  /* ---------------- 风景插画生成器（纯 SVG，离线可用，复用原 app.js） ---------------- */
  let uid = 0;
  const U = () => 'g' + (++uid);
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
      case 'heidu': return `<svg viewBox="0 0 400 225" preserveAspectRatio="xMidYMid slice">
        <defs><linearGradient id="${a}" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stop-color="#BFD0DC"/><stop offset="1" stop-color="#EEF3F6"/></linearGradient>
        <linearGradient id="${b}" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stop-color="#41414B"/><stop offset="1" stop-color="#24242C"/></linearGradient>
        <linearGradient id="${c}" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stop-color="#6F6F79"/><stop offset="1" stop-color="#3D3D47"/></linearGradient></defs>
        ${common}
        <circle cx="330" cy="44" r="21" fill="#F8F3E7" opacity=".85"/>
        <path d="M0 100 L52 72 L100 96 L152 66 L204 94 L256 70 L312 96 L400 78 L400 112 L0 112Z" fill="#A3B1BC" opacity=".45"/>
        <path d="M0 116 L44 84 L88 112 L136 80 L188 110 L242 86 L298 114 L352 88 L400 110 L400 152 L0 152Z" fill="url(#${b})"/>
        <path d="M44 84 L56 100 L34 102Z" fill="#5C5C66" opacity=".55"/>
        <path d="M188 110 L200 124 L176 126Z" fill="#5C5C66" opacity=".55"/>
        <path d="M0 148 Q70 132 140 146 Q210 160 280 144 Q340 132 400 146 L400 192 L0 192Z" fill="url(#${c})"/>
        <path d="M0 186 Q100 174 200 186 T400 180 L400 225 L0 225Z" fill="#4A4A54"/>
        <path d="M96 202 L150 193 L214 200 L286 191 L344 198" stroke="#C9A46A" stroke-width="6" fill="none" stroke-linecap="round"/>
        <g stroke="#8E7248" stroke-width="2">
          <path d="M100 208 L104 218"/><path d="M152 199 L156 211"/><path d="M216 206 L220 217"/><path d="M288 197 L292 209"/>
        </g>
        <g transform="translate(214 200)">
          <circle cx="0" cy="-30" r="5" fill="#D9523F"/>
          <rect x="-4" y="-26" width="8" height="18" rx="4" fill="#D9523F"/>
          <rect x="-3" y="-9" width="2.5" height="9" fill="#D9523F"/><rect x="1" y="-9" width="2.5" height="9" fill="#D9523F"/>
        </g>
        <g fill="#7E7E88" opacity=".5">
          <circle cx="40" cy="208" r="2.5"/><circle cx="72" cy="218" r="2"/><circle cx="124" cy="180" r="2"/>
          <circle cx="302" cy="218" r="2.5"/><circle cx="362" cy="210" r="2"/><circle cx="252" cy="172" r="1.8"/>
        </g>
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

  function routeMap() {
    const N = Object.fromEntries(MAP_NODES.map((n) => [n.id, n]));
    const pts = MAP_PATH.map((id) => `${N[id].x},${N[id].y}`).join(' ');
    const branch = MAP_BRANCH.map(([a, b]) => `<line x1="${N[a].x}" y1="${N[a].y}" x2="${N[b].x}" y2="${N[b].y}"
        stroke="#C98A2E" stroke-width="2" stroke-dasharray="6 6" opacity=".85"/>`).join('');
    const nodes = MAP_NODES.map((n) => {
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

  /* ---------------- 打卡清单（localStorage） ---------------- */
  const WKEY = 'qg_wish_v1';
  // 隐私模式 / 部分 file:// 环境下 localStorage 可能不可用，读写全部降级处理，不阻断功能
  const loadWish = () => {
    try { return JSON.parse(localStorage.getItem(WKEY)) || []; } catch (e) { return []; }
  };
  const saveWish = (arr) => {
    try { localStorage.setItem(WKEY, JSON.stringify(arr)); return true; }
    catch (e) { return false; }
  };

  /* ---------------- 子组件：景点卡片 ---------------- */
  const SpotCard = {
    props: {
      spot: { type: Object, required: true },
      inWish: { type: Boolean, default: false },
      art: { type: String, default: '' },
    },
    emits: ['open', 'toggle-wish'],
    template: '#spot-card-tpl',
  };

  /* ---------------- 根组件 ---------------- */
  const App = {
    components: { SpotCard },
    setup() {
      /* ---------- 路由状态 ---------- */
      const tab = ref('home');            // home | atlas | route | prep
      const routeMode = ref('full');      // full | compact
      const region = ref('全部');
      const search = ref('');
      const drawerSpot = ref(null);       // 当前打开的详情 spot 对象
      const wishOpen = ref(false);
      const wish = ref(loadWish());
      const quiz = reactive({ 0: undefined, 1: undefined, 2: undefined, 3: undefined });
      const toastMsg = ref('');
      let toastTimer = null;

      /* ---------- 直接引用全局数据（来自 data.js 的经典脚本全局常量） ---------- */
      // 注意：此处不要再用同名 const 重新声明 SPOTS / ALERT / DAYS 等，否则会触发 TDZ。
      // data.js 已先于本脚本加载，以下全局常量可直接在 setup 内引用，并在 return 中导出。

      const byId = (id) => SPOTS.find((s) => s.id === id);

      /* ---------- SVG 生成器（包装全局 art / routeMap） ---------- */
      const genArt = (type) => (typeof art === 'function' ? art(type) : '');
      const genMap = () => (typeof routeMap === 'function' ? routeMap() : '');

      /* ---------- 计算属性 ---------- */
      const regions = computed(() => ['全部', ...Array.from(new Set(SPOTS.map((s) => s.region)))]);

      const totalSpots = computed(() => SPOTS.length);
      const totalPhoto = computed(() => SPOTS.reduce((n, s) => n + s.photoSpots.length, 0));
      const totalFood = computed(() => SPOTS.reduce((n, s) => n + s.foods.length, 0));
      const totalBed = computed(() => SPOTS.reduce((n, s) => n + s.stays.length, 0));

      const popularIds = ['qinghaihu', 'chaka', 'dachaidan', 'dunhuang', 'zhangye', 'qilian'];
      const popular = computed(() => popularIds.map(byId).filter(Boolean));

      // 图鉴列表：区域筛选 + 关键词搜索
      const atlasList = computed(() => {
        const q = search.value.trim().toLowerCase();
        let list = SPOTS.filter((s) => region.value === '全部' || s.region === region.value);
        if (!q) return list;
        return list.filter((s) => {
          const hay = [
            s.name, s.en, s.region, s.tagline, s.desc, s.tags.join(','),
            s.highlights.map((h) => h.t + h.d).join(','),
            s.photoSpots.map((p) => p.n + p.p + p.g).join(','),
            s.foods.map((f) => f.n + f.d + f.w).join(','),
            s.stays.map((t) => t.n + t.d).join(','),
            s.tips.join(','),
          ].join(',').toLowerCase();
          return hay.includes(q);
        });
      });

      const resultText = computed(() => {
        const q = search.value.trim();
        if (q) return `搜索「${q}」：命中 ${atlasList.value.length} 站`;
        return region.value === '全部' ? `共 ${SPOTS.length} 站` : `${region.value}：共 ${atlasList.value.length} 站`;
      });

      const wishCount = computed(() => wish.value.length);

      const routeDays = computed(() => (routeMode.value === 'compact' ? DAYS_9 : DAYS));

      const budgetSum = computed(() => BUDGET.reduce((n, b) => n + Number(b.v), 0));

      // 茫崖决策器
      const quizScore = computed(() => MANGYA_QUIZ.qs.reduce((n, _, i) => n + (quiz[i] === 1 ? 1 : 0), 0));
      const quizPending = computed(() => MANGYA_QUIZ.qs.filter((_, i) => quiz[i] === undefined).length);
      const quizVerdict = computed(() => {
        if (quizPending.value) return null;
        return MANGYA_QUIZ.verdicts.find((x) => quizScore.value >= x.min);
      });

      /* ---------- 方法 ---------- */
      const toast = (msg) => {
        toastMsg.value = msg;
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => { toastMsg.value = ''; }, 1900);
      };

      const setBodyLock = (lock) => { document.body.style.overflow = lock ? 'hidden' : ''; };

      // 以 file:// 方式直接打开时，个别环境会拒绝 replaceState；
      // 退回直接改 hash——虽然会多一条历史记录，但能保证路由状态与界面一致
      const safeHash = (h) => {
        try { history.replaceState(null, '', h); return; } catch (e) { /* fallthrough */ }
        try { if (location.hash !== h) location.hash = h; } catch (e) { /* noop */ }
      };

      const openSpot = (id) => {
        const s = byId(id);
        if (!s) return;
        drawerSpot.value = s;
        setBodyLock(true);
        if (location.hash !== '#/atlas/' + id) safeHash('#/atlas/' + id);
        nextTick(() => {
          const panel = document.querySelector('.drawer-panel');
          if (panel) panel.scrollTop = 0;
        });
      };
      const closeDrawer = () => {
        drawerSpot.value = null;
        setBodyLock(false);
        if (location.hash.startsWith('#/atlas/')) safeHash('#/atlas');
      };

      // 从任意视图直达某站详情：先切到图鉴再开抽屉，不依赖 replaceState 是否成功
      const goSpot = (id) => { tab.value = 'atlas'; openSpot(id); };

      const openWish = () => { wishOpen.value = true; setBodyLock(true); };
      const closeWish = () => { wishOpen.value = false; setBodyLock(false); };

      const toggleWish = (id) => {
        const arr = wish.value.slice();
        const i = arr.indexOf(id);
        const added = i < 0;
        if (added) arr.push(id); else arr.splice(i, 1);
        wish.value = arr;
        saveWish(arr);
        toast(added ? '已加入打卡清单' : '已从清单移除');
      };

      const toggleQuiz = (i, val) => { quiz[i] = val; };

      const setTab = (t) => { location.hash = t === 'home' ? '#/home' : '#/' + t; };

      const setRouteMode = (m) => {
        routeMode.value = m;
        location.hash = m === 'compact' ? '#/route/compact' : '#/route';
      };

      const setRegion = (r) => { region.value = r; };

      const onSearch = (e) => {
        search.value = e.target.value;
        if (search.value.trim() && tab.value !== 'atlas') setTab('atlas');
      };

      const onMapClick = (e) => {
        const node = e.target.closest && e.target.closest('.map-node');
        if (node && node.dataset.id) openSpot(node.dataset.id);
      };

      // 详情内锚点滚动
      const anchorTo = (id) => {
        const el = document.getElementById(id);
        if (el) el.scrollIntoView({ behavior: 'smooth' });
      };

      // 复制工具
      const copy = (text, okMsg) => {
        const done = () => toast(okMsg || '已复制');
        const fb = () => {
          const ta = document.createElement('textarea');
          ta.value = text; ta.style.position = 'fixed'; ta.style.opacity = '0';
          document.body.appendChild(ta); ta.select();
          try { document.execCommand('copy'); done(); } catch (e) { toast('复制失败，请手动选择'); }
          ta.remove();
        };
        if (navigator.clipboard && window.isSecureContext) navigator.clipboard.writeText(text).then(done, fb);
        else fb();
      };

      const copySpot = () => {
        const s = drawerSpot.value;
        if (!s) return;
        copy(
          `${s.name}\n${s.tagline}\n\n【机位】\n${s.photoSpots.map((p, i) => `${i + 1}. ${p.n} — ${p.time}｜${p.g}`).join('\n')}\n\n【美食】\n${s.foods.map((f) => `- ${f.n} (${f.p}) ${f.d}`).join('\n')}\n\n【住宿】\n${s.stays.map((st) => `- ${st.n} ${st.p}｜优势 ${st.good}｜短板 ${st.bad}`).join('\n')}`,
          '已复制本站速查'
        );
      };

      const copyWish = () => {
        const list = wish.value.map(byId).filter(Boolean);
        copy('青甘大环线 · 我的打卡清单\n' + list.map((s, i) => `${i + 1}. ${s.name}（${s.day}）— ${s.tagline}`).join('\n'), '已复制清单');
      };

      const clearWish = () => { wish.value = []; saveWish([]); toast('已清空'); };
      const printWish = () => { window.print(); };

      /* ---------- 详情上下站 ---------- */
      // 注意：drawerSpot 是 ref，取出的对象是响应式 Proxy，不能用 indexOf 比对（会返回 -1），一律按 id 定位
      const prevSpot = computed(() => {
        const s = drawerSpot.value; if (!s) return null;
        const idx = SPOTS.findIndex((x) => x.id === s.id);
        if (idx < 0) return null;
        return SPOTS[(idx - 1 + SPOTS.length) % SPOTS.length];
      });
      const nextSpot = computed(() => {
        const s = drawerSpot.value; if (!s) return null;
        const idx = SPOTS.findIndex((x) => x.id === s.id);
        if (idx < 0) return null;
        return SPOTS[(idx + 1) % SPOTS.length];
      });

      /* ---------- 路由解析 ---------- */
      const parseHash = () => {
        const h = location.hash || '#/home';
        const m = h.match(/^#\/(home|atlas|route|prep)(?:\/([\w-]+))?$/);
        const t = m ? m[1] : 'home';
        tab.value = t;
        routeMode.value = (t === 'route' && m && m[2] === 'compact') ? 'compact' : 'full';
        if (drawerSpot.value && !(t === 'atlas' && m && m[2] && byId(m[2]))) {
          drawerSpot.value = null; setBodyLock(false);
        }
        if (t === 'atlas' && m && m[2]) {
          const s = byId(m[2]);
          if (s) { drawerSpot.value = s; setBodyLock(true); }
        }
      };

      watch(tab, () => { if (typeof window.scrollTo === 'function') window.scrollTo(0, 0); });

      onMounted(() => {
        parseHash();
        window.addEventListener('hashchange', parseHash);
        window.addEventListener('keydown', (e) => {
          if (e.key === 'Escape') { if (drawerSpot.value) closeDrawer(); if (wishOpen.value) closeWish(); }
        });
      });

      return {
        // state
        tab, routeMode, region, search, drawerSpot, wishOpen, wish, quiz, toastMsg,
        // data
        SPOTS, ALERT, DAYS, DAYS_9, COMPACT_NOTE, MANGYA_QUIZ, BOOKING, BUDGET, GEAR, DRIVE,
        byId, genArt, genMap,
        // computed
        regions, totalSpots, totalPhoto, totalFood, totalBed, popular, atlasList, resultText,
        wishCount, routeDays, budgetSum, quizScore, quizPending, quizVerdict, prevSpot, nextSpot,
        // methods
        toast, openSpot, goSpot, closeDrawer, openWish, closeWish, toggleWish, toggleQuiz, setTab,
        setRouteMode, setRegion, onSearch, onMapClick, anchorTo, copySpot, copyWish, clearWish, printWish,
      };
    },
  };

  createApp(App).mount('#app');
})();
