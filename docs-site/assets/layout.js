/* layout.js — 注入顶栏、侧栏、底栏、搜索、主题切换、面包屑
   每个页面 <body> 顶部加：
     <script src="../assets/nav-data.js"></script>
     <script src="../assets/layout.js" defer></script>
   <body> 写好 data-current="/docs-site/...html" 标记当前页
*/

(function () {
  // 1) 计算到站点根 docs-site/ 的相对前缀
  function computePrefix() {
    var path = location.pathname.replace(/\\/g, "/");
    var idx = path.indexOf("/docs-site/");
    if (idx === -1) return "";
    var after = path.substring(idx + "/docs-site/".length);
    var depth = (after.match(/\//g) || []).length;
    return depth === 0 ? "./" : new Array(depth + 1).join("../");
  }
  var PREFIX = computePrefix();

  // 把绝对路径 "/docs-site/xxx" 改成相对前缀
  function rel(href) {
    if (/^https?:/i.test(href)) return href;
    if (href.indexOf("/docs-site/") === 0) {
      return PREFIX + href.substring("/docs-site/".length);
    }
    return href;
  }

  // 2) 顶栏
  function renderTopbar() {
    var bar = document.createElement("header");
    bar.className = "pl-topbar";
    bar.innerHTML =
      '<button class="pl-topbar__menu-btn" aria-label="菜单">☰</button>' +
      '<a class="pl-topbar__brand" href="' + rel("/docs-site/index.html") + '">' +
        'product-lifecycle <small>v3.3 · 文档站</small>' +
      '</a>' +
      '<div class="pl-topbar__search">' +
        '<input type="search" placeholder="搜索文档…" autocomplete="off" />' +
        '<div class="pl-search-results"></div>' +
      '</div>' +
      '<div class="pl-topbar__links">' +
        '<a href="' + rel("/docs-site/08-glossary.html") + '">词典</a>' +
        '<a href="' + rel("/docs-site/09-faq.html") + '">FAQ</a>' +
        '<a href="' + (window.PL_SITE ? window.PL_SITE.repo : "#") + '" target="_blank" rel="noopener">GitHub</a>' +
        '<button class="pl-topbar__theme" aria-label="切换主题">🌙</button>' +
      '</div>';
    document.body.insertBefore(bar, document.body.firstChild);
  }

  // 3) 侧栏
  function renderSidebar() {
    var current = document.body.getAttribute("data-current") || "";
    var aside = document.createElement("aside");
    aside.className = "pl-sidebar";
    var html = "";
    (window.PL_NAV || []).forEach(function (section) {
      html += '<div class="pl-sidebar__section">';
      html += '<div class="pl-sidebar__title">' + section.title + '</div>';
      html += '<ul class="pl-sidebar__list">';
      section.items.forEach(function (item) {
        var active = item.href === current ? ' class="active"' : '';
        html += '<li><a href="' + rel(item.href) + '"' + active + '>' + item.text + '</a></li>';
      });
      html += '</ul></div>';
    });
    aside.innerHTML = html;
    return aside;
  }

  // 4) 包裹现有 main 内容
  function wrapMain() {
    var existing = document.querySelector("main.pl-content");
    if (!existing) {
      console.warn("[layout] 找不到 <main class='pl-content'> 节点");
      return;
    }
    var wrap = document.createElement("div");
    wrap.className = "pl-main";
    wrap.appendChild(renderSidebar());
    existing.parentNode.insertBefore(wrap, existing);
    wrap.appendChild(existing);
  }

  // 5) 底栏
  function renderFooter() {
    var f = document.createElement("footer");
    f.className = "pl-footer";
    f.innerHTML =
      'product-lifecycle 文档 · MIT 协议 · ' +
      '<a href="' + (window.PL_SITE ? window.PL_SITE.repo : "#") + '" target="_blank" rel="noopener">GitHub</a>' +
      ' · 最后更新：' + (document.lastModified || "");
    document.body.appendChild(f);
  }

  // 6) 主题切换
  function setupTheme() {
    var saved = localStorage.getItem("pl-theme");
    if (saved === "dark") document.documentElement.setAttribute("data-theme", "dark");
    document.addEventListener("click", function (e) {
      if (!e.target.classList.contains("pl-topbar__theme")) return;
      var now = document.documentElement.getAttribute("data-theme") === "dark" ? "" : "dark";
      if (now) {
        document.documentElement.setAttribute("data-theme", "dark");
        localStorage.setItem("pl-theme", "dark");
        e.target.textContent = "☀";
      } else {
        document.documentElement.removeAttribute("data-theme");
        localStorage.setItem("pl-theme", "");
        e.target.textContent = "🌙";
      }
    });
    if (saved === "dark") {
      setTimeout(function () {
        var btn = document.querySelector(".pl-topbar__theme");
        if (btn) btn.textContent = "☀";
      }, 0);
    }
  }

  // 7) 移动端菜单
  function setupMenu() {
    document.addEventListener("click", function (e) {
      if (e.target.classList.contains("pl-topbar__menu-btn")) {
        document.querySelector(".pl-sidebar").classList.toggle("--open");
      } else if (!e.target.closest(".pl-sidebar")) {
        var sb = document.querySelector(".pl-sidebar");
        if (sb) sb.classList.remove("--open");
      }
    });
  }

  // 8) 搜索（基于 PL_NAV 的标题 + 当前页文本）
  function buildIndex() {
    var idx = [];
    (window.PL_NAV || []).forEach(function (section) {
      section.items.forEach(function (item) {
        idx.push({ title: item.text, section: section.title, href: rel(item.href) });
      });
    });
    return idx;
  }
  function setupSearch() {
    var input = document.querySelector(".pl-topbar__search input");
    var box = document.querySelector(".pl-search-results");
    if (!input || !box) return;
    var idx = buildIndex();
    function render(q) {
      if (!q) { box.classList.remove("--show"); return; }
      var lower = q.toLowerCase();
      var hits = idx.filter(function (it) {
        return it.title.toLowerCase().indexOf(lower) !== -1 ||
               it.section.toLowerCase().indexOf(lower) !== -1;
      }).slice(0, 12);
      if (hits.length === 0) {
        box.innerHTML = '<div class="pl-search-results__empty">未找到「' + q + '」相关条目</div>';
      } else {
        box.innerHTML = hits.map(function (h) {
          var t = h.title.replace(new RegExp("(" + q + ")", "ig"), "<mark>$1</mark>");
          return '<a class="pl-search-results__item" href="' + h.href + '">' +
            '<div class="pl-search-results__title">' + t + '</div>' +
            '<div class="pl-search-results__path">' + h.section + '</div></a>';
        }).join("");
      }
      box.classList.add("--show");
    }
    input.addEventListener("input", function () { render(this.value.trim()); });
    input.addEventListener("focus", function () { if (this.value.trim()) render(this.value.trim()); });
    document.addEventListener("click", function (e) {
      if (!e.target.closest(".pl-topbar__search")) box.classList.remove("--show");
    });
  }

  // 9) 自动加面包屑（如果页面没写）
  function autoBreadcrumb() {
    if (document.querySelector(".pl-breadcrumb")) return;
    var current = document.body.getAttribute("data-current") || "";
    if (!current) return;
    var inSection = null, item = null;
    (window.PL_NAV || []).forEach(function (s) {
      s.items.forEach(function (it) {
        if (it.href === current) { inSection = s; item = it; }
      });
    });
    if (!inSection || !item) return;
    var main = document.querySelector("main.pl-content");
    if (!main) return;
    var bc = document.createElement("nav");
    bc.className = "pl-breadcrumb";
    bc.innerHTML =
      '<a href="' + rel("/docs-site/index.html") + '">首页</a>' +
      '<span>›</span>' + inSection.title +
      '<span>›</span>' + item.text;
    main.insertBefore(bc, main.firstChild);
  }

  // 10) 自动加上下页（基于当前位置）
  function autoPager() {
    if (document.querySelector(".pl-pager")) return;
    var current = document.body.getAttribute("data-current") || "";
    var flat = [];
    (window.PL_NAV || []).forEach(function (s) {
      s.items.forEach(function (it) { flat.push(it); });
    });
    var i = flat.findIndex(function (it) { return it.href === current; });
    if (i === -1) return;
    var prev = flat[i - 1], next = flat[i + 1];
    if (!prev && !next) return;
    var html = '<nav class="pl-pager">';
    if (prev) html += '<a class="pl-pager__link --prev" href="' + rel(prev.href) + '"><small>← 上一篇</small>' + prev.text + '</a>';
    else html += '<span></span>';
    if (next) html += '<a class="pl-pager__link --next" href="' + rel(next.href) + '"><small>下一篇 →</small>' + next.text + '</a>';
    else html += '<span></span>';
    html += '</nav>';
    var main = document.querySelector("main.pl-content");
    if (main) main.insertAdjacentHTML("beforeend", html);
  }

  // Boot
  document.addEventListener("DOMContentLoaded", function () {
    renderTopbar();
    wrapMain();
    renderFooter();
    setupTheme();
    setupMenu();
    setupSearch();
    autoBreadcrumb();
    autoPager();
  });
})();
