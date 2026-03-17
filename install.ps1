# ============================================================
# sb-flow 새 프로젝트 초기화 스크립트 (Windows PowerShell 5.x+)
# 사용법: C:\sb-flow\install.ps1 [새프로젝트-경로]
#
# 예시:
#   C:\sb-flow\install.ps1          (현재 폴더에 설치)
#   C:\sb-flow\install.ps1 .        (현재 폴더에 설치)
#   C:\sb-flow\install.ps1 C:\projects\my-app
#
# 반드시 PowerShell에서 직접 실행하세요.
# Git Bash / WSL에서 실행하면 한글 인코딩 오류가 발생합니다.
# ============================================================

param(
    [string]$ProjectDir = "."
)

# ── sb-flow 경로 자동 감지 ──────────────────────────────────
$SbflowDir = $PSScriptRoot
$TemplatesDir = Join-Path $SbflowDir "templates"

# ── 인코딩 설정 (Python rich Unicode 오류 방지) ─────────────
$env:PYTHONUTF8              = '1'
$env:PYTHONIOENCODING        = 'utf-8'
$env:PYTHONLEGACYWINDOWSSTDIO = '0'
[Console]::OutputEncoding   = [System.Text.Encoding]::UTF8

# ── 경로 절대 경로로 변환 (PowerShell 5.x 호환) ────────────
$resolved = Resolve-Path $ProjectDir -ErrorAction SilentlyContinue
if ($resolved) { $ProjectDir = $resolved.Path } else { $ProjectDir = Join-Path (Get-Location).Path $ProjectDir }

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  sb-flow 프로젝트 초기화" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  프로젝트: $ProjectDir" -ForegroundColor Green
Write-Host "  sb-flow:  $SbflowDir"  -ForegroundColor Green
Write-Host ""

# ── 유효성 검사 ─────────────────────────────────────────────
if (-not (Test-Path $ProjectDir -PathType Container)) {
    Write-Host "  프로젝트 디렉토리가 없습니다: $ProjectDir" -ForegroundColor Red
    Write-Host "  먼저 디렉토리를 생성하세요: New-Item -ItemType Directory -Path `"$ProjectDir`""
    exit 1
}

if (-not (Test-Path $TemplatesDir -PathType Container)) {
    Write-Host "  sb-flow templates 디렉토리를 찾을 수 없습니다: $TemplatesDir" -ForegroundColor Red
    exit 1
}

# ── 헬퍼: 파일 복사 (덮어쓰기 여부 확인 포함) ───────────────
function Copy-WithPrompt {
    param([string]$Src, [string]$Dst, [string]$Label)

    $DstDir = Split-Path $Dst -Parent
    if (-not (Test-Path $DstDir)) {
        New-Item -ItemType Directory -Path $DstDir -Force | Out-Null
    }

    if (Test-Path $Dst) {
        $answer = Read-Host "  $Label 이(가) 이미 있습니다. 덮어쓸까요? (y/N)"
        if ($answer -ne "y" -and $answer -ne "Y") {
            Write-Host "  건너뜀" -ForegroundColor Gray
            return
        }
    }
    Copy-Item -Path $Src -Destination $Dst -Force
    Write-Host "  [OK] $Label" -ForegroundColor Green
}

# ════════════════════════════════════════════════════════════
# [1/7] uv 설치 확인
# ════════════════════════════════════════════════════════════
Write-Host "[1/7] uv 설치 확인..." -ForegroundColor Yellow

if (Get-Command uvx -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] uv 이미 설치됨" -ForegroundColor Green
} else {
    Write-Host "  uv가 없습니다. 자동 설치를 시작합니다..." -ForegroundColor Yellow
    try {
        Invoke-Expression (Invoke-WebRequest -UseBasicParsing "https://astral.sh/uv/install.ps1").Content

        $userPath    = [System.Environment]::GetEnvironmentVariable("PATH", "User")
        $machinePath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
        $env:PATH    = "$userPath;$machinePath"

        if (Get-Command uvx -ErrorAction SilentlyContinue) {
            Write-Host "  [OK] uv 설치 완료" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "  uv 설치 후 PATH 적용을 위해 PowerShell을 재시작해야 합니다." -ForegroundColor Red
            Write-Host "  PowerShell을 닫고 다시 열어서 이 스크립트를 재실행해주세요." -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "  uv 자동 설치 실패: $_" -ForegroundColor Red
        Write-Host "  수동으로 설치해주세요: https://docs.astral.sh/uv/getting-started/installation/" -ForegroundColor Red
        exit 1
    }
}

# ════════════════════════════════════════════════════════════
# [2/7] spec-kit 초기화 (사용자 직접 실행)
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[2/7] spec-kit 초기화..." -ForegroundColor Yellow

$specifyDir = Join-Path $ProjectDir ".specify"
if (Test-Path $specifyDir) {
    Write-Host "  [OK] .specify 폴더가 이미 있습니다. 건너뜀." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  spec-kit 초기화를 직접 실행해야 합니다." -ForegroundColor Cyan
    Write-Host "  설치 중 AI 어시스턴트 등 선택 항목이 있습니다." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  새 터미널 창을 열어서 아래 명령어를 직접 실행해주세요:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  cd `"$ProjectDir`"" -ForegroundColor White
    Write-Host "  uvx --from `"git+https://github.com/github/spec-kit.git`" specify init ." -ForegroundColor White
    Write-Host ""
    Read-Host "  실행 완료 후 Enter를 눌러주세요"

    if (Test-Path $specifyDir) {
        Write-Host "  [OK] spec-kit 초기화 확인" -ForegroundColor Green
    } else {
        Write-Host "  .specify 폴더가 확인되지 않습니다. 초기화가 완료되지 않았을 수 있습니다." -ForegroundColor Yellow
        Write-Host "  계속 진행하지만, 나중에 specify init을 다시 실행해주세요." -ForegroundColor Yellow
    }
}

# ════════════════════════════════════════════════════════════
# [3/7] Vercel React Best Practices 스킬 설치 안내
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[3/7] Vercel React Best Practices 스킬 설치..." -ForegroundColor Yellow
Write-Host ""
Write-Host "  아래 명령어를 터미널에서 직접 실행해주세요." -ForegroundColor Cyan
Write-Host "  (8~10단계 /pdca plan, design, do 기준으로 사용됩니다)" -ForegroundColor Cyan
Write-Host ""
Write-Host "  npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices" -ForegroundColor White
Write-Host ""
Read-Host "  실행 완료 후 Enter를 눌러주세요"
Write-Host "  [OK] vercel-react-best-practices 스킬 설치 완료" -ForegroundColor Green

# ════════════════════════════════════════════════════════════
# [4/7] CLAUDE.md + 커스텀 명령어 복사
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[4/7] CLAUDE.md 및 커스텀 명령어 설치..." -ForegroundColor Yellow

$src = Join-Path $TemplatesDir "CLAUDE.md"
$dst = Join-Path $ProjectDir   "CLAUDE.md"
Copy-WithPrompt $src $dst "CLAUDE.md"

$commandsDir = Join-Path $ProjectDir ".claude\commands"
if (-not (Test-Path $commandsDir)) {
    New-Item -ItemType Directory -Path $commandsDir -Force | Out-Null
}

foreach ($cmd in @("sb-guide", "sb-oneshot", "sb-setup", "sb-bridge")) {
    $src = Join-Path $TemplatesDir ".claude\commands\$cmd.md"
    $dst = Join-Path $commandsDir  "$cmd.md"
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "  [OK] /$cmd" -ForegroundColor Green
    } else {
        Write-Host "  $cmd.md 파일을 찾을 수 없음" -ForegroundColor Red
    }
}

# ════════════════════════════════════════════════════════════
# [5/7] 개발 헌법 복사 (spec-kit 기본 헌법을 sb-flow 헌법으로 교체)
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[5/7] 개발 헌법 설치..." -ForegroundColor Yellow

$constitutionSrc = Join-Path $SbflowDir "constitution.md"
$constitutionDst = Join-Path $ProjectDir ".specify\memory\constitution.md"

if (Test-Path $constitutionSrc) {
    $memoryDir = Split-Path $constitutionDst -Parent
    if (-not (Test-Path $memoryDir)) {
        New-Item -ItemType Directory -Path $memoryDir -Force | Out-Null
    }
    Copy-Item -Path $constitutionSrc -Destination $constitutionDst -Force
    Write-Host "  [OK] 헌법 설치 (.specify\memory\constitution.md)" -ForegroundColor Green
} else {
    Write-Host "  constitution.md를 찾을 수 없습니다." -ForegroundColor Yellow
    Write-Host "  나중에 수동으로 복사하거나 /speckit.constitution 으로 생성하세요."
}

# ════════════════════════════════════════════════════════════
# [6/7] SDD 학습 문서 복사
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[6/7] SDD 학습 문서 설치..." -ForegroundColor Yellow

$sddGuideSrc = Join-Path $SbflowDir "sdd_guide.md"
$sddGuideDst = Join-Path $ProjectDir "sdd_guide.md"

if (Test-Path $sddGuideSrc) {
    if (-not (Test-Path $sddGuideDst)) {
        Copy-Item -Path $sddGuideSrc -Destination $sddGuideDst -Force
        Write-Host "  [OK] sdd_guide.md 설치" -ForegroundColor Green
    } else {
        Write-Host "  sdd_guide.md가 이미 있습니다. 건너뜀." -ForegroundColor Gray
    }
} else {
    Write-Host "  sdd_guide.md를 찾을 수 없습니다." -ForegroundColor Yellow
}

# ════════════════════════════════════════════════════════════
# [7/7] SPEC_CONTEXT.md 템플릿 복사
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "[7/7] SPEC_CONTEXT.md 템플릿 설치..." -ForegroundColor Yellow

$specContextSrc = Join-Path $SbflowDir "SPEC_CONTEXT.md"
$specContextDst = Join-Path $ProjectDir  "SPEC_CONTEXT.md"

if (Test-Path $specContextSrc) {
    if (-not (Test-Path $specContextDst)) {
        Copy-Item -Path $specContextSrc -Destination $specContextDst -Force
        Write-Host "  [OK] SPEC_CONTEXT.md 템플릿 설치" -ForegroundColor Green
    } else {
        Write-Host "  SPEC_CONTEXT.md가 이미 있습니다. 건너뜀." -ForegroundColor Gray
    }
} else {
    Write-Host "  SPEC_CONTEXT.md 템플릿을 찾을 수 없습니다." -ForegroundColor Yellow
}

# ════════════════════════════════════════════════════════════
# 완료
# ════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "  sb-flow 초기화 완료!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "  설치된 파일:"
Write-Host "  . CLAUDE.md                         -- 세션 자동 컨텍스트"
Write-Host "  . sdd_guide.md                      -- SDD 학습 문서"
Write-Host "  . SPEC_CONTEXT.md                   -- 브릿지 문서 템플릿"
Write-Host "  . .specify\memory\constitution.md   -- 개발 헌법"
Write-Host "  . .claude\commands\sb-guide.md      -- /sb-guide"
Write-Host "  . .claude\commands\sb-oneshot.md    -- /sb-oneshot"
Write-Host "  . .claude\commands\sb-setup.md      -- /sb-setup"
Write-Host "  . .claude\commands\sb-bridge.md     -- /sb-bridge"
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "  다음: Claude Code에서 bkit 설치" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Claude Code 실행:"
Write-Host "     claude" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Claude Code 대화창에서 bkit 설치:"
Write-Host "     /plugin marketplace add popup-studio-ai/bkit-claude-code" -ForegroundColor Cyan
Write-Host "     /plugin install bkit" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. 개발 시작:"
Write-Host "     /sb-oneshot [기능 설명]" -ForegroundColor Cyan
Write-Host ""
