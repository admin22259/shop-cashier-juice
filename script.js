'use strict';

// ---- بيانات التشغيل ----
var carts = {};   // object: tableId -> { items: [...], total: number }
var currentTable = '1';
var sales = [];   // list of sale objects
var productsList = [];

// ---- مفاتيح التخزين ----
var STORAGE_KEY_CARTS = 'juice_pos_carts';
var STORAGE_KEY_SALES = 'juice_pos_sales';
var STORAGE_KEY_USERS = 'juice_pos_users';
var STORAGE_KEY_CURRENT_USER = 'juice_pos_current_user';

// ---- نظام المستخدمين البسيط ----
// سننشئ مستخدم افتراضي حسب طلبك: اسم المستخدم "hampa" و كلمة المرور "22"
function ensureDefaultUsers() {
  try {
    var raw = localStorage.getItem(STORAGE_KEY_USERS);
    var users = raw ? JSON.parse(raw) : null;
    if (!users) {
      users = [
        { username: 'hampa', password: '22', role: 'cashier' }
      ];
      localStorage.setItem(STORAGE_KEY_USERS, JSON.stringify(users));
    }
  } catch (e) {
    console.error('خطأ في تحميل المستخدمين:', e);
  }
}

function getUsers() {
  try {
    var raw = localStorage.getItem(STORAGE_KEY_USERS);
    return raw ? JSON.parse(raw) : [];
  } catch (e) {
    return [];
  }
}

function setCurrentUser(user) {
  try {
    if (user) {
      localStorage.setItem(STORAGE_KEY_CURRENT_USER, JSON.stringify(user));
    } else {
      localStorage.removeItem(STORAGE_KEY_CURRENT_USER);
    }
  } catch (e) {
    console.error('خطأ في تعيين المستخدم الحالي:', e);
  }
}

function getCurrentUser() {
  try {
    var raw = localStorage.getItem(STORAGE_KEY_CURRENT_USER);
    return raw ? JSON.parse(raw) : null;
  } catch (e) {
    return null;
  }
}

// ---- مساعدة: حفظ/تحميل من localStorage ----
function saveCartsToStorage() {
  try {
    localStorage.setItem(STORAGE_KEY_CARTS, JSON.stringify(carts));
  } catch (e) {
    console.error('خطأ في حفظ السلات:', e);
  }
}
function loadCartsFromStorage() {
  try {
    var raw = localStorage.getItem(STORAGE_KEY_CARTS);
    if (raw) { carts = JSON.parse(raw); }
    else { carts = {}; }
  } catch (e) {
    console.error('خطأ في قراءة السلات من التخزين:', e);
    carts = {};
  }
}
function saveSalesToStorage() {
  try {
    localStorage.setItem(STORAGE_KEY_SALES, JSON.stringify(sales));
  } catch (e) {
    console.error('خطأ في حفظ المبيعات:', e);
  }
}
function loadSalesFromStorage() {
  try {
    var raw = localStorage.getItem(STORAGE_KEY_SALES);
    if (raw) { sales = JSON.parse(raw); }
    else { sales = []; }
  } catch (e) {
    console.error('خطأ في قراءة المبيعات من التخزين:', e);
    sales = [];
  }
}

// ---- إنشاء قائمة الطاولات الافتراضية (مثال 1..10) ----
function populateTableSelect(n) {
  var sel = document.getElementById('tableSelect');
  sel.innerHTML = '';
  for (var i = 1; i <= n; i++) {
    var opt = document.createElement('option');
    opt.value = String(i);
    opt.text = 'جرّاس ' + String(i);
    sel.appendChild(opt);
  }
  sel.value = currentTable;
}

// ---- تحميل المنتجات من products.json ----
function loadProducts() {
  fetch('products.json')
    .then(function(response) { return response.json(); })
    .then(function(products) {
      productsList = products;
      renderProducts();
    })
    .catch(function(err) {
      console.error('فشل تحميل products.json:', err);
      alert('خطأ: تعذر تحميل products.json');
    });
}

function escapeQuotes(text) {
  if (typeof text !== 'string') { return text; }
  return text.replace(/'/g, "\\'");
}

// ---- عرض المنتجات ----
function renderProducts() {
  var container = document.getElementById('products');
  container.innerHTML = '';
  productsList.forEach(function(prod) {
    var card = document.createElement('div');
    card.className = 'product-card';
    var h = document.createElement('h3');
    h.textContent = prod.name;
    card.appendChild(h);

    prod.sizes.forEach(function(sizeObj) {
      var row = document.createElement('div');
      row.className = 'size-row';

      var left = document.createElement('div');
      left.textContent = sizeObj.size + ' - ' + sizeObj.price + ' جنيه';

      var qtyInput = document.createElement('input');
      qtyInput.type = 'number';
      qtyInput.min = '1';
      qtyInput.value = '1';

      var btn = document.createElement('button');
      btn.textContent = 'إضافة';
      btn.onclick = (function(pn, sz, pr, inputEl) {
        return function() {
          addToCart(pn, sz, pr, inputEl.value);
        };
      })(prod.name, sizeObj.size, sizeObj.price, qtyInput);

      var right = document.createElement('div');
      right.appendChild(qtyInput);
      right.appendChild(btn);

      row.appendChild(left);
      row.appendChild(right);
      card.appendChild(row);
    });

    container.appendChild(card);
  });
}

// ---- إدارة السلة للجدول الحالي ----
function ensureCart(tableId) {
  if (!carts[tableId]) {
    carts[tableId] = { items: [], total: 0 };
  }
  return carts[tableId];
}

function changeTable() {
  var sel = document.getElementById('tableSelect');
  if (sel) {
    currentTable = sel.value;
    updateCart();
  }
}

function addToCart(product, size, price, quantity) {
  quantity = parseInt(quantity, 10);
  if (isNaN(quantity) || quantity <= 0) {
    alert('خطأ: الكمية المدخلة غير صحيحة للمنتج ' + product);
    return;
  }

  var cart = ensureCart(currentTable);
  cart.items.push({ product: product, size: size, price: price, quantity: quantity });
  cart.total = (cart.total || 0) + price * quantity;
  saveCartsToStorage();
  updateCart();
}

function updateCart() {
  var cartEl = document.getElementById('cart');
  cartEl.innerHTML = '';
  var cart = ensureCart(currentTable);
  for (var i = 0; i < cart.items.length; i++) {
    (function(idx) {
      var it = cart.items[idx];
      var li = document.createElement('li');

      var left = document.createElement('div');
      left.className = 'cart-item-left';

      var nameSpan = document.createElement('div');
      nameSpan.className = 'name';
      nameSpan.textContent = it.product;

      var metaSpan = document.createElement('div');
      metaSpan.className = 'meta';
      metaSpan.textContent = '(' + it.size + ') × ' + it.quantity + ' = ' + (it.price * it.quantity) + ' جنيه';

      left.appendChild(nameSpan);
      left.appendChild(metaSpan);

      var actions = document.createElement('div');
      actions.className = 'cart-actions';

      var btnDecrease = document.createElement('button');
      btnDecrease.textContent = '-';
      btnDecrease.className = 'btn-decrease';
      btnDecrease.onclick = function() { changeQuantity(idx, -1); };

      var btnIncrease = document.createElement('button');
      btnIncrease.textContent = '+';
      btnIncrease.className = 'btn-increase';
      btnIncrease.onclick = function() { changeQuantity(idx, +1); };

      var btnRemove = document.createElement('button');
      btnRemove.textContent = 'حذف';
      btnRemove.className = 'btn-remove';
      btnRemove.onclick = function() { removeFromCart(idx); };

      actions.appendChild(btnDecrease);
      actions.appendChild(btnIncrease);
      actions.appendChild(btnRemove);

      li.appendChild(left);
      li.appendChild(actions);
      cartEl.appendChild(li);
    })(i);
  }

  var totalSpan = document.getElementById('total');
  totalSpan.textContent = (cart.total || 0);

  // عرض اسم المستخدم الحالي في الواجهة
  var user = getCurrentUser();
  var loggedSpan = document.getElementById('loggedUser');
  var btnLogout = document.getElementById('btnLogout');
  var btnShowLogin = document.getElementById('btnShowLogin');
  if (user) {
    if (loggedSpan) { loggedSpan.textContent = 'المستخدم: ' + user.username; }
    if (btnLogout) { btnLogout.style.display = 'inline-block'; }
    if (btnShowLogin) { btnShowLogin.style.display = 'none'; }
  } else {
    if (loggedSpan) { loggedSpan.textContent = ''; }
    if (btnLogout) { btnLogout.style.display = 'none'; }
    if (btnShowLogin) { btnShowLogin.style.display = 'inline-block'; }
  }
}

// تغيير كمية عنصر محدد (delta = ±1)
function changeQuantity(index, delta) {
  var cart = ensureCart(currentTable);
  if (index < 0 || index >= cart.items.length) { return; }
  var item = cart.items[index];
  var newQty = parseInt(item.quantity, 10) + delta;
  if (newQty <= 0) {
    removeFromCart(index);
    return;
  }
  cart.total = cart.total - (item.price * item.quantity) + (item.price * newQty);
  item.quantity = newQty;
  saveCartsToStorage();
  updateCart();
}

function removeFromCart(index) {
  var cart = ensureCart(currentTable);
  if (index < 0 || index >= cart.items.length) { return; }
  var item = cart.items[index];
  cart.total = cart.total - (item.price * item.quantity);
  cart.items.splice(index, 1);
  saveCartsToStorage();
  updateCart();
}

function clearCurrentCart() {
  if (!confirm('هل تريد تفريغ السلة للطاولة الحالية؟')) { return; }
  carts[currentTable] = { items: [], total: 0 };
  saveCartsToStorage();
  updateCart();
}

// ---- عمليات تتطلب تسجيل دخول ----
function isAuthenticated() {
  return !!getCurrentUser();
}

function requireAuth(actionCallback) {
  if (!isAuthenticated()) {
    alert('مطلوب تسجيل دخول لأداء هذه العملية.');
    showLogin();
    return;
  }
  actionCallback();
}

// Wrapper functions that check auth
function attemptCheckout() {
  requireAuth(checkout);
}
function attemptPrintInvoice() {
  requireAuth(printThermal);
}
function attemptShowSalesReport() {
  requireAuth(showSalesReport);
}
function attemptExportSalesCSV() {
  requireAuth(exportSalesCSV);
}
function attemptResetAllData() {
  requireAuth(resetAllData);
}

// ---- checkout: تسجيل الفاتورة في sales وحفظها ----
function checkout() {
  var cart = ensureCart(currentTable);
  if (!cart.items || cart.items.length === 0) {
    alert('السلة فارغة!');
    return;
  }
  var sale = {
    table: currentTable,
    items: cart.items.slice(), // نسخة
    total: cart.total || 0,
    time: (new Date()).toISOString(),
    user: (getCurrentUser() ? getCurrentUser().username : 'unknown')
  };
  sales.push(sale);
  saveSalesToStorage();

  // تفريغ السلة بعد الدفع
  carts[currentTable] = { items: [], total: 0 };
  saveCartsToStorage();
  updateCart();

  alert('تم الدفع وتسجيل الفاتورة. الإجمالي: ' + sale.total + ' جنيه');
}

// ---- دالة طباعة مُهيأة للطابعات الحرارية ----
function printThermal() {
  var cart = ensureCart(currentTable);
  if (!cart.items || cart.items.length === 0) {
    alert('السلة فارغة!');
    return;
  }

  // نص الفاتورة بصيغة مناسبة للطابعة الحرارية -- عرض ضيق، خط أحادي
  var txt = '';
  txt += '***** محل العصاير *****\n';
  txt += 'الطاولة: ' + currentTable + '\n';
  txt += 'المستخدم: ' + (getCurrentUser() ? getCurrentUser().username : '') + '\n';
  txt += '-----------------------------\n';
  for (var i = 0; i < cart.items.length; i++) {
    var it = cart.items[i];
    var line = it.product + ' ' + it.size + ' x' + it.quantity + ' ' + (it.price * it.quantity) + 'ج\n';
    txt += line;
  }
  txt += '-----------------------------\n';
  txt += 'الإجمالي: ' + (cart.total || 0) + 'ج\n';
  txt += 'الوقت: ' + (new Date()).toLocaleString() + '\n';
  txt += '\n\n';

  // نفتح نافذة طباعة بسيطة مع نمط ضيق
  var w = window.open('', '_blank', 'width=320,height=600');
  if (!w) { alert('منع النوافذ المنبثقة. فعّل السماح لفتح النوافذ للطباعة.'); return; }

  var html = '<!doctype html><html><head><meta charset="utf-8"><title>فاتورة للطباعة</title>';
  html += '<style>';
  html += 'body { font-family: monospace; font-size: 12px; width: 280px; }';
  html += '@media print { @page { size: 80mm auto; margin: 0; } body { margin: 5mm; } }';
  html += '</style></head><body><pre>' + txt.replace(/&/g, '&amp;').replace(/</g,'&lt;') + '</pre></body></html>';

  w.document.open();
  w.document.write(html);
  w.document.close();
  // ننتظر قليلاً ثم أمر الطباعة (قد تحتاج لاختيار الطابعة يدوياً)
  setTimeout(function() { w.print(); }, 500);
}

// ---- عرض تقرير المبيعات (نافذة) ----
function showSalesReport() {
  if (!sales || sales.length === 0) {
    alert('لا توجد مبيعات حتى الآن!');
    return;
  }
  var html = '<!doctype html><html><head><meta charset="utf-8"><title>تقرير المبيعات</title></head><body>';
  html += '<h2>تقرير المبيعات (' + sales.length + ' فاتورة)</h2>';
  html += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;width:100%">';
  html += '<thead><tr><th>#</th><th>الطاولة</th><th>الوقت</th><th>المستخدم</th><th>العناصر</th><th>الإجمالي</th></tr></thead><tbody>';

  for (var i = 0; i < sales.length; i++) {
    var s = sales[i];
    var itemsText = '';
    for (var j = 0; j < s.items.length; j++) {
      var it = s.items[j];
      itemsText += it.product + ' (' + it.size + ') x' + it.quantity + ' = ' + (it.price * it.quantity) + 'ج; ';
    }
    html += '<tr><td>' + (i+1) + '</td><td>' + s.table + '</td><td>' + s.time + '</td><td>' + (s.user || '') + '</td><td>' + itemsText + '</td><td>' + s.total + '</td></tr>';
  }

  html += '</tbody></table>';
  html += '</body></html>';

  var w = window.open('', '_blank', 'width=1000,height=700');
  if (!w) { alert('منع النوافذ المنبثقة. فعّل السماح لعرض التقرير.'); return; }
  w.document.open();
  w.document.write(html);
  w.document.close();
}

// ---- تصدير CSV لتقارير المبيعات ----
function exportSalesCSV() {
  if (!sales || sales.length === 0) { alert('لا توجد مبيعات لتصديرها'); return; }
  var lines = [];
  lines.push(['رقم الفاتورة','الطاولة','الوقت','المستخدم','العناصر (؛ مفصولة)','الإجمالي'].join(','));

  for (var i = 0; i < sales.length; i++) {
    var s = sales[i];
    var itemsText = '';
    for (var j = 0; j < s.items.length; j++) {
      var it = s.items[j];
      var part = it.product + ' (' + it.size + ') x' + it.quantity + ' = ' + (it.price * it.quantity) + 'ج';
      part = part.replace(/,/g, '،');
      itemsText += part;
      if (j < s.items.length - 1) { itemsText += ' ; '; }
    }
    var row = [
      String(i+1),
      s.table,
      s.time,
      (s.user || ''),
      '"' + itemsText + '"',
      String(s.total)
    ].join(',');
    lines.push(row);
  }

  var csv = lines.join('\n');
  var csvContent = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
  var link = document.createElement('a');
  link.setAttribute('href', csvContent);
  link.setAttribute('download', 'sales_report.csv');
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

// ---- إعادة تعيين كامل للبيانات المحلية (تنبيه) ----
function resetAllData() {
  if (!confirm('تحذير: سيُمسح كل شيء من localStorage (السلات والمبيعات والمستخدمين). هل أنت متأكد؟')) { return; }
  localStorage.removeItem(STORAGE_KEY_CARTS);
  localStorage.removeItem(STORAGE_KEY_SALES);
  localStorage.removeItem(STORAGE_KEY_USERS);
  localStorage.removeItem(STORAGE_KEY_CURRENT_USER);
  carts = {};
  sales = [];
  ensureDefaultUsers();
  updateCart();
  alert('تم مسح البيانات المحلية وإعادة إنشاء المستخدم الافتراضي.');
}

// ---- تسجيل الدخول / الخروج ----
function showLogin() {
  var sec = document.getElementById('loginSection');
  if (sec) { sec.style.display = 'block'; }
}
function hideLogin() {
  var sec = document.getElementById('loginSection');
  var msg = document.getElementById('loginMsg');
  if (sec) { sec.style.display = 'none'; }
  if (msg) { msg.textContent = ''; }
}
function login() {
  var userInput = document.getElementById('loginUser').value;
  var passInput = document.getElementById('loginPass').value;
  var msg = document.getElementById('loginMsg');
  var users = getUsers();
  var found = null;
  for (var i = 0; i < users.length; i++) {
    if (users[i].username === userInput && users[i].password === passInput) { found = users[i]; break; }
  }
  if (found) {
    setCurrentUser({ username: found.username, role: found.role });
    if (msg) { msg.style.color = 'green'; msg.textContent = 'تم تسجيل الدخول.'; }
    hideLogin();
    updateCart();
  } else {
    if (msg) { msg.style.color = 'red'; msg.textContent = 'اسم المستخدم أو كلمة المرور غير صحيحة.'; }
  }
}
function logout() {
  setCurrentUser(null);
  updateCart();
  alert('تم تسجيل الخروج.');
}

// ---- تهيئة عند التحميل ----
document.addEventListener('DOMContentLoaded', function() {
  ensureDefaultUsers();
  populateTableSelect(10); // عدل العدد لو تريد طاولات أكثر/أقل
  loadCartsFromStorage();
  loadSalesFromStorage();
  loadProducts(); // بعد تحميل المنتجات سيتم عرضها
  updateCart();
});