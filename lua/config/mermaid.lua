-- Mermaid (.mmd) のブラウザプレビュー。
--
-- .mmd では <leader>m で mmdc (mermaid-cli) を使い、最新 mermaid で SVG 化して
-- ブラウザに表示する。markdown (.md) 側の <leader>m (markdown-preview.nvim) は
-- ui.lua で別途定義されており、こちらとは独立 (filetype ごとのバッファローカル
-- 割り当てなので、開いているファイルに応じて自動で振り分かる)。

-- *.mmd / *.mermaid を mermaid filetype として認識させる
vim.filetype.add({
  extension = {
    mmd = "mermaid",
    mermaid = "mermaid",
  },
})

-- mmdc (mermaid-cli) で現在の .mmd を SVG 化し、HTML に包んでブラウザで開く。
--
-- mkdp の同梱 mermaid は parse 失敗時に黙ってテキスト化するが、mmdc は最新の
-- mermaid を使うため確実に描画でき、構文エラーは理由付きで報告される。
local cache = vim.fn.stdpath("cache")
local svg_path = cache .. "/mermaid-preview.svg"
local html_path = cache .. "/mermaid-preview.html"

local function render()
  if vim.fn.executable("mmdc") == 0 then
    vim.notify("mmdc (mermaid-cli) が見つかりません: brew install mermaid-cli", vim.log.levels.ERROR)
    return
  end

  -- バッファ内容を一時 .mmd に書き出し (未保存・無名でも動くように)
  local src_mmd = cache .. "/mermaid-preview.mmd"
  vim.fn.writefile(vim.api.nvim_buf_get_lines(0, 0, -1, false), src_mmd)

  vim.notify("mermaid: レンダリング中…", vim.log.levels.INFO)
  vim.system(
    { "mmdc", "-i", src_mmd, "-o", svg_path, "-b", "white" },
    { text = true },
    vim.schedule_wrap(function(out)
      if out.code ~= 0 then
        vim.notify("mermaid 描画失敗:\n" .. (out.stderr ~= "" and out.stderr or out.stdout), vim.log.levels.ERROR)
        return
      end
      -- SVG をインラインし、Figma 風のホイールズーム/ドラッグパンを仕込んだ
      -- HTML を生成する (CDN 不要・全てインライン)。
      -- ズーム/パンは CSS transform ではなく SVG の viewBox を直接操作する。
      -- transform:scale はラスタライズ後に拡大するためボケるが、viewBox 操作は
      -- 都度ベクターを再描画するので何倍に拡大してもクッキリ保たれる。
      local head = {
        [[<!doctype html><meta charset="utf-8"><title>mermaid preview</title>]],
        [[<style>]],
        [[  html,body{margin:0;height:100%;overflow:hidden;background:#fff}]],
        [[  #vp{width:100vw;height:100vh;overflow:hidden;cursor:grab}]],
        [[  #vp.drag{cursor:grabbing}]],
        [[  #vp>svg{display:block;width:100vw;height:100vh}]],
        [[  #hint{position:fixed;bottom:8px;left:8px;font:12px -apple-system,sans-serif;]],
        [[    color:#888;background:#ffffffcc;padding:4px 8px;border-radius:4px}]],
        [[</style>]],
        [[<div id="vp">]],
      }
      local tail = {
        [[</div>]],
        [[<div id="hint">scroll: パン ・ ⌘/⌃+scroll / ピンチ: ズーム ・ ドラッグ: パン ・ ダブルクリック: リセット</div>]],
        [[<script>]],
        [[(function(){]],
        [[  var vp=document.getElementById('vp'),svg=vp.querySelector('svg');]],
        [[  svg.removeAttribute('width');svg.removeAttribute('height');]],
        [[  if(!svg.getAttribute('viewBox')){try{var b=svg.getBBox();]],
        [[    svg.setAttribute('viewBox',b.x+' '+b.y+' '+b.width+' '+b.height);}catch(e){}}]],
        [[  var p=svg.getAttribute('viewBox').split(/[ ,]+/).map(Number);]],
        [[  var base={x:p[0],y:p[1],w:p[2],h:p[3]},vb={x:p[0],y:p[1],w:p[2],h:p[3]};]],
        [[  function set(){svg.setAttribute('viewBox',vb.x+' '+vb.y+' '+vb.w+' '+vb.h);}]],
        [[  function toUser(cx,cy){var pt=svg.createSVGPoint();pt.x=cx;pt.y=cy;]],
        [[    return pt.matrixTransform(svg.getScreenCTM().inverse());}]],
        [[  vp.addEventListener('wheel',function(e){e.preventDefault();]],
        [[    if(e.metaKey||e.ctrlKey){var f=Math.exp(-e.deltaY*0.01),nw=vb.w/f;]],
        [[      if(nw<base.w/200||nw>base.w*200)return;var c=toUser(e.clientX,e.clientY);]],
        [[      vb.x=c.x-(c.x-vb.x)/f;vb.y=c.y-(c.y-vb.y)/f;vb.w/=f;vb.h/=f;set();}]],
        [[    else{var o=toUser(0,0),d=toUser(e.deltaX,e.deltaY);]],
        [[      vb.x+=(d.x-o.x);vb.y+=(d.y-o.y);set();}},{passive:false});]],
        [[  var drag=false,lx=0,ly=0;]],
        [[  vp.addEventListener('pointerdown',function(e){drag=true;lx=e.clientX;ly=e.clientY;]],
        [[    vp.classList.add('drag');vp.setPointerCapture(e.pointerId);});]],
        [[  vp.addEventListener('pointermove',function(e){if(!drag)return;]],
        [[    var u1=toUser(lx,ly),u2=toUser(e.clientX,e.clientY);]],
        [[    vb.x-=(u2.x-u1.x);vb.y-=(u2.y-u1.y);set();lx=e.clientX;ly=e.clientY;});]],
        [[  vp.addEventListener('pointerup',function(){drag=false;vp.classList.remove('drag');});]],
        [[  vp.addEventListener('dblclick',function(){vb={x:base.x,y:base.y,w:base.w,h:base.h};set();});]],
        [[})();]],
        [[</script>]],
      }
      local html = {}
      vim.list_extend(html, head)
      vim.list_extend(html, vim.fn.readfile(svg_path))
      vim.list_extend(html, tail)
      vim.fn.writefile(html, html_path)
      vim.system({ "open", html_path })
    end)
  )
end

-- mermaid ファイルで <leader>m に mmdc 描画を割り当て
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mermaid",
  callback = function(args)
    vim.keymap.set("n", "<leader>m", render, {
      buffer = args.buf, silent = true, desc = "Mermaid Render (mmdc / browser)",
    })
  end,
})
