" ===========================================================================
" ОСНОВНЫЕ НАСТРОЙКИ
" ===========================================================================

set encoding=utf-8
scriptencoding utf-8

set number
set relativenumber
syntax on

" Отступы
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

" Производительность и UX
set updatetime=300          " Быстрый обновляемый CursorHold
set signcolumn=yes          " Фиксированная ширина для диагностики
set hidden                  " Позволяет переключаться между буферами без сохранения
set termguicolors           " Поддержка true color
let g:airline#extensions#tabline#enabled = 1           " enable airline tabline                                                           
let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline                                            
let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)      
let g:airline#extensions#tabline#fnamemod = ':t'       " disable file paths in the tab                                                    
let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right                                                           
let g:airline#extensions#tabline#show_buffers = 0      " dont show buffers in the tabline                                                 
let g:airline#extensions#tabline#tab_min_count = 2     " minimum of 2 tabs needed to display the tabline                                  
let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline               
let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers                                                              
let g:airline#extensions#tabline#show_tab_type = 0     " disables the weird ornage arrow on the tabline

" Безопасность и совместимость
set nobackup
set nowritebackup


" ===========================================================================
" ПЛАГИНЫ (Vim-Plug)
" ===========================================================================

call plug#begin()

Plug 'mason-org/mason.nvim'
Plug 'mason-org/mason-lspconfig.nvim'

Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'igorlfs/nvim-dap-view'

Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'

" UI / Темы
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'ryanoasis/vim-devicons'

" Навигация
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP / Интеллект
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" UX / Feedback
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Терминал
Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

" Удобство
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

call plug#end()


" ===========================================================================
" TOGGLETERM.NVIM
" ===========================================================================

lua << EOF
require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-t>]],
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  start_in_insert = true,
  float_opts = {
    border = "single",
    winblend = 0,
    highlights = {
      border = "Normal",
    }
  }
})
EOF

" Маппинги (альтернатива через vimscript, но Lua-конфиг выше лучше)
nnoremap <silent><leader>t <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><leader>t <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>


" ===========================================================================
" NERDTREE
" ===========================================================================

let NERDTreeMinimalUI = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', 'node_modules', '\.git']

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n>     :NERDTree<CR>
nnoremap <S-e>     :NERDTreeToggle<CR>
nnoremap <C-f>     :NERDTreeFind<CR>


" ===========================================================================
" COC.NVIM — LSP / DIAGNOSTICS / COMPLETION
" ===========================================================================

" Автодополнение
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Навигация по коду
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Документация
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Подсветка при удержании курсора
autocmd CursorHold * silent call CocActionAsync('highlight')

" Переименование
nmap <leader>rn <Plug>(coc-rename)

" Форматирование
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocActionAsync('format')
augroup coc_format
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Code Actions
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(coc-codeaction-source)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" CodeLens
nmap <leader>cl <Plug>(coc-codelens-action)

" Text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Прокрутка float-окон
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Selection range
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Команды
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR   :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Statusline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoCList
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>


" ===========================================================================
" СЕССИИ (AUTOSAVE / AUTOLOAD)
" ===========================================================================

autocmd VimLeavePre * silent! mksession! ~/.vim_session.vim
autocmd VimEnter * nested if argc() == 0 && filereadable(expand('~/.vim_session.vim'))
  \ | source ~/.vim_session.vim | endif


" ===========================================================================
" ОСТАЛЬНОЕ
" ===========================================================================

" Noice.nvim
lua require("noice").setup()


" ===========================================================================
" ЦВЕТОВАЯ СХЕМА
" ===========================================================================

let ayucolor = "dark"
colorscheme ayu

" FZF маппинги
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fw :Windows<CR>
nnoremap <leader>fh :History<CR>


" ===========================================================================
" DAP (DEBUG ADAPTER PROTOCOL)
" ===========================================================================

" Маппинги для дебага
nnoremap <F5>  :lua require'dap'.continue()<CR>
nnoremap <F6>  :lua require'dap'.step_over()<CR>
nnoremap <F7>  :lua require'dap'.step_into()<CR>
nnoremap <F8>  :lua require'dap'.step_out()<CR>
nnoremap <F9>  :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <F10> :lua require'dap'.terminate()<CR>

nnoremap <leader>db :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>dB :lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>
nnoremap <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <leader>dv :lua require'dap-view'.toggle()<CR>

lua << EOF
-- Mason setup
require("mason").setup()

-- DAP View setup (UI для дебага)
require("dap-view").setup()

-- Иконки для breakpoints
vim.fn.sign_define('DapBreakpoint', { text='●', texthl='DiagnosticError', linehl='', numhl='' })
vim.fn.sign_define('DapBreakpointCondition', { text='◐', texthl='DiagnosticWarn', linehl='', numhl='' })
vim.fn.sign_define('DapLogPoint', { text='◆', texthl='DiagnosticInfo', linehl='', numhl='' })
vim.fn.sign_define('DapStopped', { text='▶', texthl='DiagnosticOk', linehl='DiffAdd', numhl='' })
vim.fn.sign_define('DapBreakpointRejected', { text='○', texthl='DiagnosticHint', linehl='', numhl='' })

local dap = require("dap")

local mason_path = vim.fn.stdpath("data") .. "/mason"
local js_debug_path = mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

dap.adapters["pwa-node"] = function(callback, config)
  local port = math.random(10000, 50000)
  callback({
    type = "server",
    host = "127.0.0.1",
    port = port,
    executable = {
      command = "node",
      args = { js_debug_path, tostring(port), "127.0.0.1" },
    }
  })
end

-- Конфигурации для JS/TS
for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
  dap.configurations[lang] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Запуск текущего файла",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Запуск через npm (debug)",
      runtimeExecutable = "npm",
      runtimeArgs = { "run", "start:debug" },
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach к процессу",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach к localhost:9229",
      address = "localhost",
      port = 9229,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
  }
end

-- Автооткрытие dap-view при старте дебага
dap.listeners.after.event_initialized["dap-view"] = function()
  require("dap-view").open()
end
EOF
