"""generate_preview.py - Line-based state machine parser for 디자인.md → preview.html"""
import re, html as html_mod

with open('design-constitution.md', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# ─── STATE MACHINE ───
chapters = []      # list of { title, sections: [{ title, items: [{ title, desc, html_blocks, css_blocks }] }] }
cur_chapter = None
cur_section = None
cur_item = None
in_html_block = False
in_css_block = False
block_buf = []

for line in lines:
    stripped = line.rstrip('\n').rstrip('\r')

    # --- Code block boundaries ---
    if stripped.startswith('```html'):
        in_html_block = True
        block_buf = []
        continue
    if stripped.startswith('```css'):
        in_css_block = True
        block_buf = []
        continue
    if stripped == '```' and (in_html_block or in_css_block):
        code = '\n'.join(block_buf)
        if cur_item:
            if in_html_block:
                cur_item['html_blocks'].append(code)
            elif in_css_block:
                cur_item['css_blocks'].append(code)
        in_html_block = False
        in_css_block = False
        block_buf = []
        continue
    if in_html_block or in_css_block:
        block_buf.append(stripped)
        continue

    # --- ## Chapter heading ---
    m = re.match(r'^## (.+)$', stripped)
    if m:
        cur_chapter = {'title': m.group(1).strip(), 'sections': [], 'items': []}
        chapters.append(cur_chapter)
        cur_section = None
        cur_item = None
        continue

    # --- ### Section heading ---
    m = re.match(r'^### (.+)$', stripped)
    if m and cur_chapter is not None:
        cur_section = {'title': m.group(1).strip(), 'items': []}
        cur_chapter['sections'].append(cur_section)
        cur_item = None
        continue

    # --- **XX. Item title** ---
    m = re.match(r'^\*\*(\d{2}\..+?)\*\*$', stripped)
    if m:
        cur_item = {'title': m.group(1).strip(), 'desc': '', 'html_blocks': [], 'css_blocks': []}
        if cur_section is not None:
            cur_section['items'].append(cur_item)
        elif cur_chapter is not None:
            cur_chapter['items'].append(cur_item)
        continue

    # --- Description line (first - bullet after item header) ---
    if cur_item and not cur_item['desc'] and stripped.startswith('- '):
        cur_item['desc'] = stripped[2:].strip()[:150]

# ─── HTML GENERATION ───
chapter_colors = {
    'Ⅰ': '#475569', 'Ⅱ': '#7c3aed', 'Ⅲ': '#1a42e5',
    'Ⅳ': '#059669', 'Ⅴ': '#d97706', 'Ⅵ': '#db2777',
}
chapter_labels = {
    'Ⅰ': 'Ⅰ 원칙', 'Ⅱ': 'Ⅱ 스타일', 'Ⅲ': 'Ⅲ 컴포넌트',
    'Ⅳ': 'Ⅳ 기본패턴', 'Ⅴ': 'Ⅴ 서비스패턴', 'Ⅵ': 'Ⅵ 디자인토큰',
}

nav_html = []
body_html = []
sec_id = 0
total_previews = 0

def get_chapter_key(title):
    for k in chapter_colors:
        if k in title:
            return k
    return ''

def render_item(item):
    global total_previews
    out = []
    out.append(f'<div class="mb-8">')
    out.append(f'  <h3 class="text-base font-bold text-blue-800 mb-1 flex items-center gap-2">')
    out.append(f'    <span class="w-1 h-4 bg-blue-600 inline-block rounded-full"></span>')
    out.append(f'    {html_mod.escape(item["title"])}')
    out.append(f'  </h3>')
    if item['desc']:
        out.append(f'  <p class="text-sm text-gray-500 mb-3 ml-3">{html_mod.escape(item["desc"])}</p>')
    
    # CSS 항목 시각화
    for css_code in item['css_blocks']:
        out.append(f'  <style>{css_code}</style>')
        
        # 간단한 CSS 파싱해서 미리보기 박스 생성
        import re
        
        # 카테고리별로 색상 변수 분류
        css_var_groups = {}
        current_group = "기본 색상"
        
        for line in css_code.split('\n'):
            line = line.strip()
            if not line: continue
            
            # 그룹 헤더 주석 찾기: /* 1. 주조색 ... */
            m_group = re.match(r'/\*\s*(.*?)\s*\*/', line)
            if m_group and '--' not in line:
                current_group = m_group.group(1).strip()
                if current_group not in css_var_groups:
                    css_var_groups[current_group] = []
                continue
            
            # CSS 변수 찾기
            m_var = re.search(r'--([a-zA-Z0-9_-]+)\s*:\s*(#[0-9a-fA-F]{3,8}|rgba?\([^)]+\))(.*?);', line)
            if m_var:
                var_name = m_var.group(1)
                val = m_var.group(2)
                rest = m_var.group(3)
                comment = ''
                m_comment = re.search(r'/\*\s*(.*?)\s*\*/', rest)
                if m_comment:
                    comment = m_comment.group(1).strip()
                
                if current_group not in css_var_groups:
                    css_var_groups[current_group] = []
                css_var_groups[current_group].append((var_name, val, comment))

        classes = re.findall(r'\.([a-zA-Z0-9_-]+)\s*\{', css_code)
        
        if css_var_groups or classes:
            out.append('  <div class="p-5 border border-gray-200 rounded-lg bg-white shadow-sm preview-box mb-2">')
            
            if css_var_groups:
                for grp_name, gvars in css_var_groups.items():
                    if not gvars: continue
                    out.append(f'    <div class="mb-6 last:mb-0">')
                    out.append(f'      <h4 class="text-sm font-bold text-gray-800 mb-3 pb-2 border-b border-gray-100 flex items-center gap-1.5"><span class="text-xs bg-gray-100 px-1.5 py-0.5 rounded text-gray-500">🔖</span> {html_mod.escape(grp_name)}</h4>')
                    out.append('      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">')
                    for var_name, hex_color, comment in gvars:
                        desc_html = f'<div class="text-[10px] text-gray-500 mt-1 leading-tight">{html_mod.escape(comment)}</div>' if comment else ''
                        out.append(f'''
                        <div class="flex flex-col border border-gray-100 rounded-lg overflow-hidden shadow-sm hover:shadow-md transition-shadow">
                          <div class="h-16 w-full" style="background-color: {hex_color};"></div>
                          <div class="p-3 bg-white">
                            <div class="text-[11px] font-bold text-gray-900 mb-0.5">{hex_color.upper()}</div>
                            <div class="text-[10px] font-mono text-gray-400 leading-tight">var(--{var_name})</div>
                            {desc_html}
                          </div>
                        </div>
                        ''')
                    out.append('      </div>')
                    out.append('    </div>')
                
            if classes:
                out.append('    <div class="flex flex-wrap gap-4 pt-4 border-t border-gray-100">')
                for cls in classes:
                    # 색상 관련 클래스는 좀 더 크게, 그 외에는 일반 박스
                    if 'bg-' in cls or 'text-' in cls or 'border-' in cls:
                        out.append(f'      <div class="flex flex-col items-center">')
                        out.append(f'        <div class="w-16 h-16 rounded shadow-sm border border-gray-200 flex items-center justify-center {cls}"></div>')
                        out.append(f'        <span class="text-xs text-gray-500 mt-2 font-mono">.{cls}</span>')
                        out.append(f'      </div>')
                    else:
                        out.append(f'      <div class="px-3 py-1.5 border border-gray-200 bg-gray-50 rounded text-xs font-mono text-gray-600">.{cls}</div>')
                out.append('    </div>')
                
            out.append('  </div>')
    
    for html_code in item['html_blocks']:
        total_previews += 1
        out.append(f'  <div class="p-5 border border-gray-200 rounded-lg bg-white shadow-sm preview-box mb-2">')
        out.append(f'    {html_code}')
        out.append(f'  </div>')
    
    if not item['html_blocks'] and not item['css_blocks']:
        pass
    
    out.append(f'</div>')
    return '\n'.join(out)

for chapter in chapters:
    ck = get_chapter_key(chapter['title'])
    color = chapter_colors.get(ck, '#475569')
    label = chapter_labels.get(ck, '')
    
    # Chapter-level items (like Style section)
    if chapter['items']:
        sec_id += 1
        sid = f's{sec_id}'
        nav_html.append(f'<li class="mt-3"><span style="background:{color}" class="text-white text-xs font-bold px-2 py-0.5 rounded">{label}</span></li>')
        nav_html.append(f'<li><a href="#{sid}" class="hover:text-white px-2 py-0.5 rounded block text-sm">{html_mod.escape(chapter["title"][:35])}</a></li>')
        
        body_html.append(f'<section id="{sid}" class="mb-14 pt-6">')
        body_html.append(f'<h2 class="text-2xl font-bold mb-5 text-gray-900 border-b-4 border-gray-900 pb-2">{html_mod.escape(chapter["title"])}</h2>')
        for item in chapter['items']:
            body_html.append(render_item(item))
        body_html.append('</section>')
    
    # Section-level items
    first_in_ch = True
    for section in chapter['sections']:
        if not section['items']:
            continue
        sec_id += 1
        sid = f's{sec_id}'
        
        if first_in_ch and not chapter['items']:
            nav_html.append(f'<li class="mt-3"><span style="background:{color}" class="text-white text-xs font-bold px-2 py-0.5 rounded">{label}</span></li>')
            first_in_ch = False
        
        nav_html.append(f'<li><a href="#{sid}" class="hover:text-white px-2 py-0.5 rounded block text-sm">{html_mod.escape(section["title"][:35])}</a></li>')
        
        body_html.append(f'<section id="{sid}" class="mb-14 pt-6">')
        body_html.append(f'<h2 class="text-xl font-bold mb-5 text-gray-900 border-b-4 border-gray-900 pb-2">{html_mod.escape(section["title"])}</h2>')
        for item in section['items']:
            body_html.append(render_item(item))
        body_html.append('</section>')

total_sections = body_html.count('</section>')

final_html = f'''<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>디자인 헌법 Live Preview ({total_previews} components)</title>
  <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/@phosphor-icons/web"></script>
  <script>
    tailwind.config = {{
      theme: {{
        extend: {{
          fontFamily: {{ sans: ['Pretendard', 'sans-serif'] }},
          colors: {{
            primary: {{ 50: '#ebf4ff', 100: '#d0e3ff', 200: '#a9c7ff', 300: '#7aa5ff', 400: '#5583ff', 500: '#3563ff', 600: '#1a42e5', 700: '#102eb8', 800: '#0d2794', 900: '#0a2176' }},
          }}
        }}
      }}
    }}
  </script>
  <style>
    *:focus-visible {{ outline: 2px solid #000; outline-offset: 2px; }}
    .btn-primary {{ background-color: #1a42e5; color: #fff; border: none; padding: 8px 16px; border-radius: 8px; font-weight: bold; cursor: pointer; }}
    .btn-primary:hover {{ background-color: #102eb8; }}
    .btn-secondary {{ background: transparent; color: #475569; border: 1px solid #475569; padding: 8px 16px; border-radius: 8px; font-weight: bold; cursor: pointer; }}
    .btn-text {{ background: transparent; color: #1a42e5; text-decoration: underline; border: none; padding: 8px 16px; cursor: pointer; }}
    .preview-box .fixed {{ position: relative !important; bottom: auto !important; left: auto !important; right: auto !important; top: auto !important; transform: none !important; z-index: 0 !important; }}
    .preview-box {{ min-height: 40px; }}
  </style>
  <script>
    document.addEventListener('DOMContentLoaded', () => {{
      // Replace empty placeholder SVGs with Phosphor Icons
      const iconMap = {{
        '돋보기': 'ph-magnifying-glass',
        '검색': 'ph-magnifying-glass',
        '체크': 'ph-check-circle',
        '닫기': 'ph-x',
        'x': 'ph-x',
        '새로고침': 'ph-arrows-clockwise',
        'user': 'ph-user',
        '유저': 'ph-user',
        '제출': 'ph-paper-plane-right',
        '필터': 'ph-faders',
        'chevron': 'ph-caret-down',
        '화살표': 'ph-arrow-right',
        '다운로드': 'ph-download-simple',
        '문서': 'ph-file-text',
        'svg paths': 'ph-spinner-gap', // 스피너
        'spinner': 'ph-spinner-gap'
      }};
      
      document.querySelectorAll('svg').forEach(svg => {{
        if (!svg.querySelector('path') && !svg.querySelector('circle') && !svg.querySelector('rect') && !svg.querySelector('polygon')) {{
          let dictKey = '';
          const comment = Array.from(svg.childNodes).find(n => n.nodeType === 8);
          if (comment) dictKey = comment.textContent.trim().toLowerCase();
          else if (svg.className.baseVal) dictKey = svg.className.baseVal.toLowerCase();
          else if (svg.getAttribute('aria-label')) dictKey = svg.getAttribute('aria-label').toLowerCase();
          
          let phClass = 'ph-star'; // default fallback
          for (const [key, val] of Object.entries(iconMap)) {{
            if (dictKey.includes(key)) {{ phClass = val; break; }}
          }}
          // spin 애니메이션 클래스가 있는 경우 강제 스피너 매핑
          if (svg.classList.contains('animate-spin')) phClass = 'ph-spinner-gap';
          
          const i = document.createElement('i');
          const baseClass = svg.className.baseVal || 'w-5 h-5';
          // w-5 h-5 equivalent in font size is around 1.25rem (20px)
          i.className = `ph ${{phClass}} ${{baseClass}} flex items-center justify-center text-[1.25em]`;
          if (svg.hasAttribute('aria-hidden')) i.setAttribute('aria-hidden', 'true');
          svg.replaceWith(i);
        }}
      }});

      // Modal: hide initially, add open button
      document.querySelectorAll('.preview-box div[role="dialog"]').forEach(d => {{
        const ov = d.previousElementSibling;
        d.classList.add('hidden');
        if(ov && ov.getAttribute('aria-hidden')==='true') ov.classList.add('hidden');
        const box = d.closest('.preview-box');
        if(box && !box.dataset.modalBtn) {{
          box.dataset.modalBtn = '1';
          const b = document.createElement('button');
          b.textContent = '🔲 모달 열기';
          b.className = 'px-3 py-1 bg-gray-800 text-white text-xs rounded mb-3 hover:bg-gray-600';
          box.prepend(b);
          b.onclick = () => {{ d.classList.remove('hidden'); if(ov) ov.classList.remove('hidden'); }};
        }}
        d.querySelectorAll('button').forEach(cb => cb.addEventListener('click', () => {{
          d.classList.add('hidden'); if(ov) ov.classList.add('hidden');
        }}));
      }});
      // Accordion / Disclosure toggle
      document.querySelectorAll('button[aria-controls]').forEach(btn => {{
        btn.addEventListener('click', () => {{
          const t = document.getElementById(btn.getAttribute('aria-controls'));
          if(!t) return;
          const exp = btn.getAttribute('aria-expanded')==='true';
          btn.setAttribute('aria-expanded', String(!exp));
          t.classList.toggle('hidden', exp);
        }});
      }});
    }});
  </script>
</head>
<body class="bg-gray-50 flex text-gray-800 font-sans">
  <aside class="w-64 fixed h-screen bg-gray-900 text-white overflow-y-auto p-5 hidden lg:block shadow-xl z-[99]">
    <h1 class="text-base font-bold mb-1 border-b border-gray-700 pb-3">📋 디자인 헌법 Preview</h1>
    <p class="text-xs text-gray-500 mb-5">{total_sections} sections · {total_previews} live previews</p>
    <ul class="space-y-0.5 text-gray-400">
      {''.join(nav_html)}
    </ul>
  </aside>
  <main class="lg:ml-64 p-5 md:p-10 w-full max-w-6xl">
    <div class="bg-blue-50 p-6 mb-10 rounded-xl border border-blue-200">
      <h1 class="text-2xl font-bold text-gray-900 mb-1">🏛️ 대한민국 디지털 정부서비스 UI/UX 디자인 헌법</h1>
      <p class="text-sm text-blue-800"><code>generate_preview.py</code>가 <strong>디자인.md</strong>를 파싱 → <strong>{total_sections}개 섹션</strong>, <strong>{total_previews}개 HTML 예시</strong> 100% 렌더링</p>
    </div>
    {''.join(body_html)}
  </main>
</body>
</html>'''

with open('preview.html', 'w', encoding='utf-8') as f:
    f.write(final_html)

print(f'✅ {total_sections} sections, {total_previews} live previews → preview.html')
