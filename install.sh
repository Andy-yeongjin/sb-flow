#!/bin/bash

# ============================================================
# sb-flow 새 프로젝트 초기화 스크립트 (macOS / Linux)
# 사용법: ~/sb-flow/install.sh [새프로젝트-경로]
#
# 예시:
#   ~/sb-flow/install.sh              (현재 폴더에 설치)
#   ~/sb-flow/install.sh .            (현재 폴더에 설치)
#   ~/sb-flow/install.sh ~/projects/my-app
# ============================================================

set -e

# ── 색상 설정 ──────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ── sb-flow 경로 자동 감지 ─────────────────────────────────
SBFLOW_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$SBFLOW_DIR/templates"

# ── 인수 처리 ──────────────────────────────────────────────
PROJECT_DIR="${1:-.}"
PROJECT_DIR=$(realpath "$PROJECT_DIR")

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}  sb-flow 프로젝트 초기화${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "  프로젝트: ${GREEN}$PROJECT_DIR${RESET}"
echo -e "  sb-flow:  ${GREEN}$SBFLOW_DIR${RESET}"
echo ""

# ── 유효성 검사 ────────────────────────────────────────────
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}  프로젝트 디렉토리가 없습니다: $PROJECT_DIR${RESET}"
    echo "  먼저 프로젝트 디렉토리를 생성하세요: mkdir -p $PROJECT_DIR"
    exit 1
fi

if [ ! -d "$TEMPLATES_DIR" ]; then
    echo -e "${RED}  sb-flow templates 디렉토리를 찾을 수 없습니다: $TEMPLATES_DIR${RESET}"
    exit 1
fi

# ── 헬퍼: 파일 복사 (덮어쓰기 여부 확인 포함) ───────────────
copy_with_prompt() {
    local src="$1" dst="$2" label="$3"
    local dst_dir
    dst_dir=$(dirname "$dst")
    mkdir -p "$dst_dir"

    if [ -f "$dst" ]; then
        echo -n "  $label 이(가) 이미 있습니다. 덮어쓸까요? (y/N) "
        read -r answer
        if [ "$answer" != "y" ] && [ "$answer" != "Y" ]; then
            echo "  건너뜀"
            return
        fi
    fi
    cp "$src" "$dst"
    echo -e "  ${GREEN}[OK] $label${RESET}"
}

# ════════════════════════════════════════════════════════════
# [1/7] uv 설치 확인
# ════════════════════════════════════════════════════════════
echo -e "${YELLOW}[1/7] uv 설치 확인...${RESET}"

if command -v uvx &> /dev/null; then
    echo -e "  ${GREEN}[OK] uv 이미 설치됨${RESET}"
else
    echo -e "  ${YELLOW}uv가 없습니다. 자동 설치를 시작합니다...${RESET}"
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # PATH 갱신
    export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

    if command -v uvx &> /dev/null; then
        echo -e "  ${GREEN}[OK] uv 설치 완료${RESET}"
    else
        echo -e "  ${RED}uv 설치 후 PATH 적용을 위해 터미널을 재시작해야 합니다.${RESET}"
        echo -e "  ${RED}터미널을 닫고 다시 열어서 이 스크립트를 재실행해주세요.${RESET}"
        exit 1
    fi
fi

# ════════════════════════════════════════════════════════════
# [2/7] spec-kit 초기화 (사용자 직접 실행)
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[2/7] spec-kit 초기화...${RESET}"

SPECIFY_DIR="$PROJECT_DIR/.specify"
if [ -d "$SPECIFY_DIR" ]; then
    echo -e "  ${GREEN}[OK] .specify 폴더가 이미 있습니다. 건너뜀.${RESET}"
else
    echo ""
    echo -e "  ${CYAN}spec-kit 초기화를 직접 실행해야 합니다.${RESET}"
    echo -e "  ${CYAN}설치 중 AI 어시스턴트 등 선택 항목이 있습니다.${RESET}"
    echo ""
    echo -e "  ${YELLOW}새 터미널 창을 열어서 아래 명령어를 직접 실행해주세요:${RESET}"
    echo ""
    echo "  cd \"$PROJECT_DIR\""
    echo "  uvx --from \"git+https://github.com/github/spec-kit.git\" specify init ."
    echo ""
    read -p "  실행 완료 후 Enter를 눌러주세요" _

    if [ -d "$SPECIFY_DIR" ]; then
        echo -e "  ${GREEN}[OK] spec-kit 초기화 확인${RESET}"
    else
        echo -e "  ${YELLOW}.specify 폴더가 확인되지 않습니다. 초기화가 완료되지 않았을 수 있습니다.${RESET}"
        echo "  계속 진행하지만, 나중에 specify init을 다시 실행해주세요."
    fi
fi

# ════════════════════════════════════════════════════════════
# [3/7] Vercel React Best Practices 스킬 설치 안내
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[3/7] Vercel React Best Practices 스킬 설치...${RESET}"
echo ""
echo -e "  ${CYAN}아래 명령어를 터미널에서 직접 실행해주세요.${RESET}"
echo -e "  ${CYAN}(8~10단계 /pdca plan, design, do 기준으로 사용됩니다)${RESET}"
echo ""
echo "  npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices"
echo ""
read -p "  실행 완료 후 Enter를 눌러주세요" _
echo -e "  ${GREEN}[OK] vercel-react-best-practices 스킬 설치 완료${RESET}"

# ════════════════════════════════════════════════════════════
# [4/7] CLAUDE.md + 커스텀 명령어 복사
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[4/7] CLAUDE.md 및 커스텀 명령어 설치...${RESET}"

copy_with_prompt "$TEMPLATES_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md" "CLAUDE.md"

mkdir -p "$PROJECT_DIR/.claude/commands"

COMMANDS=("sb-guide" "sb-oneshot" "sb-setup" "sb-bridge")
for cmd in "${COMMANDS[@]}"; do
    src="$TEMPLATES_DIR/.claude/commands/${cmd}.md"
    dst="$PROJECT_DIR/.claude/commands/${cmd}.md"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
        echo -e "  ${GREEN}[OK] /${cmd}${RESET}"
    else
        echo -e "  ${RED}${cmd}.md 파일을 찾을 수 없음${RESET}"
    fi
done

# ════════════════════════════════════════════════════════════
# [5/7] 개발 헌법 복사
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[5/7] 개발 헌법 설치...${RESET}"

CONSTITUTION_SRC="$SBFLOW_DIR/constitution.md"
CONSTITUTION_DST="$PROJECT_DIR/.specify/memory/constitution.md"

if [ -f "$CONSTITUTION_SRC" ]; then
    mkdir -p "$PROJECT_DIR/.specify/memory"
    cp "$CONSTITUTION_SRC" "$CONSTITUTION_DST"
    echo -e "  ${GREEN}[OK] 헌법 설치 (.specify/memory/constitution.md)${RESET}"
else
    echo -e "  ${YELLOW}constitution.md를 찾을 수 없습니다.${RESET}"
    echo "  나중에 수동으로 복사하거나 /speckit.constitution 으로 생성하세요."
fi

# ════════════════════════════════════════════════════════════
# [6/7] SDD 학습 문서 복사
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[6/7] SDD 학습 문서 설치...${RESET}"

SDD_GUIDE_SRC="$SBFLOW_DIR/sdd_guide.md"
SDD_GUIDE_DST="$PROJECT_DIR/sdd_guide.md"

if [ -f "$SDD_GUIDE_SRC" ]; then
    if [ ! -f "$SDD_GUIDE_DST" ]; then
        cp "$SDD_GUIDE_SRC" "$SDD_GUIDE_DST"
        echo -e "  ${GREEN}[OK] sdd_guide.md 설치${RESET}"
    else
        echo "  sdd_guide.md가 이미 있습니다. 건너뜀."
    fi
else
    echo -e "  ${YELLOW}sdd_guide.md를 찾을 수 없습니다.${RESET}"
fi

# ════════════════════════════════════════════════════════════
# [7/7] SPEC_CONTEXT.md 템플릿 복사
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${YELLOW}[7/7] SPEC_CONTEXT.md 템플릿 설치...${RESET}"

SPEC_CONTEXT_SRC="$SBFLOW_DIR/SPEC_CONTEXT.md"
SPEC_CONTEXT_DST="$PROJECT_DIR/SPEC_CONTEXT.md"

if [ -f "$SPEC_CONTEXT_SRC" ]; then
    if [ ! -f "$SPEC_CONTEXT_DST" ]; then
        cp "$SPEC_CONTEXT_SRC" "$SPEC_CONTEXT_DST"
        echo -e "  ${GREEN}[OK] SPEC_CONTEXT.md 템플릿 설치${RESET}"
    else
        echo "  SPEC_CONTEXT.md가 이미 있습니다. 건너뜀."
    fi
else
    echo -e "  ${YELLOW}SPEC_CONTEXT.md 템플릿을 찾을 수 없습니다.${RESET}"
fi

# ════════════════════════════════════════════════════════════
# 완료
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}  sb-flow 초기화 완료!${RESET}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "  설치된 파일:"
echo -e "  . ${BLUE}CLAUDE.md${RESET}                         -- 세션 자동 컨텍스트"
echo -e "  . ${BLUE}sdd_guide.md${RESET}                      -- SDD 학습 문서"
echo -e "  . ${BLUE}SPEC_CONTEXT.md${RESET}                   -- 브릿지 문서 템플릿"
echo -e "  . ${BLUE}.specify/memory/constitution.md${RESET}   -- 개발 헌법"
echo -e "  . ${BLUE}.claude/commands/sb-guide.md${RESET}      -- /sb-guide"
echo -e "  . ${BLUE}.claude/commands/sb-oneshot.md${RESET}    -- /sb-oneshot"
echo -e "  . ${BLUE}.claude/commands/sb-setup.md${RESET}      -- /sb-setup"
echo -e "  . ${BLUE}.claude/commands/sb-bridge.md${RESET}     -- /sb-bridge"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${YELLOW}  다음: Claude Code에서 bkit 설치${RESET}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "  1. Claude Code 실행:"
echo -e "     ${CYAN}claude${RESET}"
echo ""
echo "  2. Claude Code 대화창에서 bkit 설치:"
echo -e "     ${CYAN}/plugin marketplace add popup-studio-ai/bkit-claude-code${RESET}"
echo -e "     ${CYAN}/plugin install bkit${RESET}"
echo ""
echo "  3. 개발 시작:"
echo -e "     ${CYAN}/sb-oneshot [기능 설명]${RESET}"
echo ""
