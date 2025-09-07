CREATE DATABASE IF NOT EXISTS hampa_pos;
USE hampa_pos;

CREATE TABLE sizes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO sizes (name) VALUES
('صغير'),
('وسط'),
('كبير'),
('كان'),
('نص لتر'),
('لتر'),
('لتر ونص');


CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(50)
);

CREATE TABLE prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size_id INT NOT NULL,
    price DECIMAL(6,3),
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (size_id) REFERENCES sizes(id)
);


INSERT INTO prices (product_id, size_id, price) VALUES
(1, 1, 2.000),
(1, 2, NULL),
(1, 3, NULL),
(1, 4, NULL),
(1, 5, NULL),
(1, 6, NULL),
(1, 7, NULL);



CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total DECIMAL(8,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE invoice_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(6,3)
);
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    password VARCHAR(255),
    role VARCHAR(20)
);
CREATE TABLE permissions (
    role VARCHAR(20) PRIMARY KEY,
    can_add_invoice BOOLEAN DEFAULT 0,
    can_close_day BOOLEAN DEFAULT 0,
    can_manage_products BOOLEAN DEFAULT 0,
    can_print_invoice BOOLEAN DEFAULT 0
);
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(50),
    price_small DECIMAL(6,3),
    price_medium DECIMAL(6,3),
    price_large DECIMAL(6,3),
    price_can DECIMAL(6,3),
    price_half_litre DECIMAL(6,3),
    price_litre DECIMAL(6,3),
    price_one_and_half_litre DECIMAL(6,3)
);
CREATE TABLE permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role VARCHAR(20),
    can_add_invoice BOOLEAN,
    can_close_day BOOLEAN,
    can_edit_product BOOLEAN
);
CREATE TABLE close_day (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_sales DECIMAL(10,3),
    closed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE print_invoice (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT,
    printed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,3) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE invoice_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    product_id INT NOT NULL,
    size VARCHAR(50) DEFAULT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10,3) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE invoice_print (
    print_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    printed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);
CREATE TABLE day_close (
    close_id INT AUTO_INCREMENT PRIMARY KEY,
    total_sales DECIMAL(10,3) NOT NULL,
    closed_by INT NOT NULL,
    closed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (closed_by) REFERENCES users(user_id)
);
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('cashier1', 'cash123', 'cashier'),
('waiter1', 'waiter123', 'waiter');
INSERT INTO permissions (role, can_add_invoice, can_close_day, can_manage_products, can_print_invoice) VALUES
('admin', 1, 1, 1, 1),
('cashier', 1, 0, 0, 1),
('waiter', 1, 0, 0, 0);
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('cashier1', 'cash123', 'cashier'),
('waiter1', 'waiter123', 'waiter');

INSERT INTO products (name, category) VALUES
('AMAZON', 'Dishes'),
('HAMPA DISH', 'Dishes'),
('MANGO DISH', 'Dishes'),
('KIWI', 'Fruitsalad');

-- إضافة أسعار لكل حجم
INSERT INTO prices (product_id, size, price) VALUES
(1, NULL, 2.000),
(2, NULL, 1.500),
(3, NULL, 1.400),
(4, 'صغير', 1.200),
(4, 'وسط', 1.800);
INSERT INTO products (name, category) VALUES
('AMAZON', 'Dishes'),
('HAMPA DISH', 'Dishes'),
('MANGO DISH', 'Dishes'),
('SLALAH DISH', 'Dishes'),
('FLAMNGO', 'Dishes'),
('SUPER HAMPA', 'Dishes'),
('OMANI DISH', 'Dishes'),
('PLATINUM DISH', 'Dishes'),
('KIWI', 'Fruitsalad'),
('STRAWBERRY', 'Fruitsalad'),
('POMEGRANAT', 'Fruitsalad'),
('PINAPPLE', 'Fruitsalad'),
('WATER MELON', 'Fruitsalad'),
('MIX SALAD', 'Fruitsalad'),
('fakfakena', 'shakf'),
('samdy', 'shakf'),
('maloka', 'shakf'),
('hamode', 'shakf'),
('crestaal', 'shakf'),
('wafeel', 'sweet'),
('crepe', 'sweet'),
('crepe fotochine', 'sweet'),
('crepe rool', 'sweet'),
('mini bancake 8', 'sweet'),
('mini pancake18', 'sweet'),
('bnana greek', 'greacyougert'),
('pomegranate greek', 'greacyougert'),
('mango greek', 'greacyougert'),
('greek granola', 'greacyougert'),
('strawberry greek', 'greacyougert'),
('avocado honey greek', 'greacyougert'),
('ريد بول نكهات', 'Drinks'),
('ريد بول سلاش', 'Drinks'),
('نكهات7UP', 'Drinks'),
('7UP سلاش', 'Drinks'),
('نكهاتV.C', 'Drinks'),
('سلاشV.C', 'Drinks'),
('مانجو', 'fresh'),
('فراوله', 'fresh'),
('برتقال', 'fresh'),
('اناناس', 'fresh'),
('بطيخ', 'fresh'),
('شمام', 'fresh'),
('رمان', 'fresh'),
('كيوي', 'fresh'),
('كركديه', 'fresh'),
('موز حليب', 'fresh'),
('جريب فروت', 'fresh'),
('باشون فروت', 'fresh'),
('ليمون/ليمون نعناع', 'fresh'),
('جزر', 'fresh'),
('شمندر', 'fresh'),
('عنب', 'fresh'),
('تفاح احمر / اخضر', 'fresh'),
('خوخ', 'fresh'),
('افوكادو ساده', 'fresh'),
('افوكادو عسل', 'fresh'),
('افوكادو عسل ومكسرات', 'fresh'),
('nuttela ice cream', 'ice cream'),
('louts ice cream', 'ice cream'),
('kinder ice cream', 'ice cream'),
('pistachio ice cream', 'ice cream'),
('marbel ice cream', 'ice cream'),
('maltezer ice cream', 'ice cream'),
('mango ice cream', 'ice cream'),
('Rob Mango', 'roob'),
('rob strawberry', 'roob'),
('ROB BERIES', 'roob'),
('ROB PASSION', 'roob'),
('POMEGRANAT ROB', 'roob'),
('ROB DATES', 'roob'),
('SHAKE VANILIA', 'milkshake'),
('SHAKE MALTEZER', 'milkshake'),
('KETKAT', 'milkshake'),
('SHAKE KINDER', 'milkshake'),
('FLAKE', 'milkshake'),
('GALXY', 'milkshake'),
('SHAKE LOUTS', 'milkshake'),
('SHAKE NUTTILA', 'milkshake'),
('OREO', 'milkshake'),
('SHAKE PISTACHO', 'milkshake'),
('SHAKE MIX', 'milkshake'),
('CERELAC', 'milkshake'),
('SHAKE MANGO', 'milkshake'),
('SHAKE BANANA', 'milkshake'),
('SHAKE MARS', 'milkshake'),
('SHAKE STRAWBERRY', 'milkshake'),
('SHAKE BLUE BERRY', 'milkshake'),
('SHAKE RED BERRY', 'milkshake'),
('SLASH SHAKE', 'milkshake'),
('الكينج', 'hambaspeshal'),
('برج السعاده', 'hambaspeshal'),
('الامبراطور', 'hambaspeshal'),
('عوار قلب', 'hambaspeshal'),
('فيروز', 'hambaspeshal'),
('شروق', 'hambaspeshal'),
('ريلاكس', 'hambaspeshal'),
('روتانا', 'hambaspeshal'),
('فرحه', 'hambaspeshal'),
('جنه', 'hambaspeshal'),
('بهجه', 'hambaspeshal'),
('كيان', 'hambaspeshal'),
('مكس باشون', 'hambaspeshal'),
('زوزو', 'hambaspeshal'),
('فيتامين جرين', 'hambaspeshal'),
('جرين ميلون', 'hambaspeshal'),
('بينك ليمونادا', 'hambaspeshal'),
('سوبر امبراطور', 'hambaspeshal'),
('سوبر عوار قلب', 'hambaspeshal'),
('افوكادو مانجو', 'hambaspeshal'),
('بلاك بيري', 'hambaspeshal'),
('عمده', 'hambaspeshal'),
('غاليا', 'hambaspeshal'),
('صاروخ', 'hambaspeshal'),
('تايجحر', 'hambaspeshal'),
('افوكادو فراوله', 'hambaspeshal'),
('افوكادو برتقال اناناس', 'hambaspeshal'),
('برتقال اناناس', 'hambaspeshal'),
('برتقال مانجو', 'hambaspeshal'),
('مانجو اناناس', 'hambaspeshal'),
('اناناس باشون', 'hambaspeshal'),
('باشون برتقال', 'hambaspeshal'),
('باشون مانجو', 'hambaspeshal'),
('باشون اناناس', 'hambaspeshal'),
('مانجو فراوله', 'hambaspeshal'),
('كوكتيل طبقات', 'hambaspeshal'),
('افوكادو طبقات', 'hambaspeshal'),
('شمندر برتقال', 'hambaspeshal'),
('شمندر جزر', 'hambaspeshal'),
('شمندر رمان', 'hambaspeshal');
INSERT INTO prices (product_name, size, price) VALUES
-- Dishes
('AMAZON', 'صغير', 2.000),
('HAMPA DISH', 'صغير', 1.500),
('MANGO DISH', 'صغير', 1.400),
('SLALAH DISH', 'صغير', 1.800),
('FLAMNGO', 'صغير', 1.200),
('SUPER HAMPA', 'صغير', 3.400),
('OMANI DISH', 'صغير', 2.000),
('PLATINUM DISH', 'صغير', 1.800),
-- Fruitsalad
('KIWI', 'صغير', 1.200),
('KIWI', 'وسط', 1.800),
('STRAWBERRY', 'صغير', 1.200),
('STRAWBERRY', 'وسط', 1.800),
('POMEGRANAT', 'صغير', 1.500),
('POMEGRANAT', 'وسط', 2.100),
('PINAPPLE', 'صغير', 1.200),
('PINAPPLE', 'وسط', 1.800),
('WATER MELON', 'صغير', 1.200),
('WATER MELON', 'وسط', 1.800),
('MIX SALAD', 'صغير', 1.200),
('MIX SALAD', 'وسط', 1.800),
-- shakf
('fakfakena', 'صغير', 1.100),
('fakfakena', 'وسط', 1.400),
('fakfakena', 'كبير', 1.600),
('samdy', 'صغير', 1.100),
('samdy', 'وسط', 1.400),
('samdy', 'كبير', 1.600),
('maloka', 'وسط', 1.900),
('maloka', 'كبير', 2.400),
('hamode', 'صغير', 1.400),
('hamode', 'وسط', 1.900),
('hamode', 'كبير', 2.400),
('crestaal', 'صغير', 1.400),
('crestaal', 'وسط', 1.900),
('crestaal', 'كبير', 2.400),
-- sweet
('wafeel', 'وسط', 2.300),
('crepe', 'وسط', 1.900),
('crepe fotochine', 'وسط', 1.900),
('crepe rool', 'وسط', 2.200),
('mini bancake 8', 'صغير', 1.050),
('mini pancake18', 'وسط', 1.900),
-- greacyougert
('bnana greek', 'وسط', 1.500),
('pomegranate greek', 'وسط', 1.500),
('mango greek', 'وسط', 1.500),
('greek granola', 'وسط', 1.800),
('strawberry greek', 'وسط', 1.500),
('avocado honey greek', 'وسط', 1.800),
-- Drinks (أحجام متعددة)
('ريد بول نكهات', 'صغير', 1.800),
('ريد بول نكهات', 'وسط', 2.200),
('ريد بول نكهات', 'كبير', 2.400),
('ريد بول نكهات', 'كان', 2.400),
('ريد بول سلاش', 'صغير', 1.800),
('ريد بول سلاش', 'وسط', 2.200),
('ريد بول سلاش', 'كبير', 2.400),
('ريد بول سلاش', 'كان', 2.400),
('نكهات7UP', 'صغير', 1.000),
('نكهات7UP', 'وسط', 1.200),
('نكهات7UP', 'كبير', 1.500),
('نكهات7UP', 'كان', 1.600),
('7UP سلاش', 'صغير', 1.000),
('7UP سلاش', 'وسط', 1.200),
('7UP سلاش', 'كبير', 1.500),
('7UP سلاش', 'كان', 1.600),
('نكهاتV.C', 'صغير', 1.800),
('نكهاتV.C', 'وسط', 2.200),
('نكهاتV.C', 'كبير', 2.400),
('نكهاتV.C', 'كان', 2.400),
('سلاشV.C', 'صغير', 2.000),
('سلاشV.C', 'وسط', 2.400),
('سلاشV.C', 'كبير', 2.600),
('سلاشV.C', 'كان', 2.600);
- fresh
INSERT INTO prices (product_name, size, price) VALUES
('مانجو','صغير',0.900),('مانجو','وسط',1.200),('مانجو','كبير',1.500),('مانجو','كان',1.600),('مانجو','نص لتر',1.600),('مانجو','لتر',3.500),('مانجو','لتر ونص',4.000),
('فراوله','صغير',0.800),('فراوله','وسط',1.100),('فراوله','كبير',1.400),('فراوله','كان',1.400),('فراوله','نص لتر',1.500),('فراوله','لتر',2.900),('فراوله','لتر ونص',3.800),
('برتقال','صغير',0.800),('برتقال','وسط',1.100),('برتقال','كبير',1.400),('برتقال','كان',1.400),('برتقال','نص لتر',1.500),('برتقال','لتر',3.000),('برتقال','لتر ونص',3.600),
('اناناس','صغير',0.800),('اناناس','وسط',1.100),('اناناس','كبير',1.400),('اناناس','كان',1.400),('اناناس','نص لتر',1.500),('اناناس','لتر',2.800),('اناناس','لتر ونص',3.300),
('بطيخ','صغير',0.700),('بطيخ','وسط',1.000),('بطيخ','كبير',1.300),('بطيخ','كان',1.500),('بطيخ','نص لتر',1.500),('بطيخ','لتر',2.800),('بطيخ','لتر ونص',3.200),
('شمام','صغير',0.700),('شمام','وسط',1.000),('شمام','كبير',1.200),('شمام','كان',1.400),('شمام','نص لتر',1.400),('شمام','لتر',2.900),('شمام','لتر ونص',3.200),
('رمان','صغير',0.900),('رمان','وسط',1.200),('رمان','كبير',1.500),('رمان','كان',1.500),('رمان','نص لتر',1.600),('رمان','لتر',3.000),('رمان','لتر ونص',3.800),
('كيوي','صغير',0.800),('كيوي','وسط',1.100),('كيوي','كبير',1.400),('كيوي','كان',1.500),('كيوي','نص لتر',1.500),('كيوي','لتر',2.800),('كيوي','لتر ونص',3.600),
('كركديه','صغير',0.500),('كركديه','وسط',0.800),('كركديه','كبير',1.000),('كركديه','كان',1.000),('كركديه','نص لتر',1.100),('كركديه','لتر',1.800),('كركديه','لتر ونص',2.600),
('موز حليب','صغير',0.600),('موز حليب','وسط',0.900),('موز حليب','كبير',1.000),('موز حليب','كان',1.300),('موز حليب','نص لتر',1.400),('موز حليب','لتر',2.100),('موز حليب','لتر ونص',2.800);
INSERT INTO prices (product_name, size, price) VALUES
('nuttela ice cream','وسط',1.400),
('louts ice cream','وسط',1.400),('louts ice cream','كبير',1.600),
('kinder ice cream','وسط',1.400),
('pistachio ice cream','وسط',1.600),
('marbel ice cream','وسط',1.400),
('maltezer ice cream','وسط',1.400),
('mango ice cream','وسط',1.400);

-- roob
INSERT INTO prices (product_name, size, price) VALUES
('Rob Mango','صغير',0.900),('Rob Mango','وسط',1.200),('Rob Mango','كبير',1.500),('Rob Mango','كان',1.500),('Rob Mango','نص لتر',1.600),('Rob Mango','لتر',3.000),('Rob Mango','لتر ونص',3.400),
('rob strawberry','صغير',0.900),('rob strawberry','وسط',1.200),('rob strawberry','كبير',1.500),('rob strawberry','كان',1.500),('rob strawberry','نص لتر',1.600),('rob strawberry','لتر',3.000),('rob strawberry','لتر ونص',3.400),
('ROB BERIES','صغير',0.900),('ROB BERIES','وسط',1.200),('ROB BERIES','كبير',1.500),('ROB BERIES','كان',1.500),('ROB BERIES','نص لتر',1.600),('ROB BERIES','لتر',3.000),('ROB BERIES','لتر ونص',3.400),
('ROB PASSION','صغير',0.900),('ROB PASSION','وسط',1.200),('ROB PASSION','كبير',1.500),('ROB PASSION','كان',1.500),('ROB PASSION','نص لتر',1.600),('ROB PASSION','لتر',3.000),('ROB PASSION','لتر ونص',3.400),
('POMEGRANAT ROB','صغير',0.900),('POMEGRANAT ROB','وسط',1.200),('POMEGRANAT ROB','كبير',1.500),('POMEGRANAT ROB','كان',1.500),('POMEGRANAT ROB','نص لتر',1.600),('POMEGRANAT ROB','لتر',3.000),('POMEGRANAT ROB','لتر ونص',3.400),
('ROB DATES','صغير',1.000),('ROB DATES','وسط',1.300),('ROB DATES','كبير',1.600),('ROB DATES','كان',1.600),('ROB DATES','نص لتر',1.900),('ROB DATES','لتر',3.800),('ROB DATES','لتر ونص',4.200);

-- milkshake
INSERT INTO prices (product_name, size, price) VALUES
('SHAKE VANILIA','صغير',0.800),('SHAKE VANILIA','وسط',1.100),('SHAKE VANILIA','كبير',1.400),('SHAKE VANILIA','كان',1.500),('SHAKE VANILIA','نص لتر',1.500),('SHAKE VANILIA','لتر',3.000),('SHAKE VANILIA','لتر ونص',4.000),
('SHAKE MALTEZER','صغير',0.800),('SHAKE MALTEZER','وسط',1.100),('SHAKE MALTEZER','كبير',1.400),('SHAKE MALTEZER','كان',1.500),('SHAKE MALTEZER','نص لتر',1.500),('SHAKE MALTEZER','لتر',3.000),('SHAKE MALTEZER','لتر ونص',4.000),
('KETKAT','صغير',0.800),('KETKAT','وسط',1.100),('KETKAT','كبير',1.400),('KETKAT','كان',1.500),('KETKAT','نص لتر',1.500),('KETKAT','لتر',3.000),('KETKAT','لتر ونص',4.000),
('SHAKE KINDER','صغير',0.800),('SHAKE KINDER','وسط',1.100),('SHAKE KINDER','كبير',1.400),('SHAKE KINDER','كان',1.500),('SHAKE KINDER','نص لتر',1.500),('SHAKE KINDER','لتر',3.000),('SHAKE KINDER','لتر ونص',4.000);
-- hambaspeshal
INSERT INTO prices (product_name, size, price) VALUES
('الكينج','وسط',1.200),('الكينج','كبير',1.600),
('برج السعاده','وسط',1.500),('برج السعاده','كبير',1.800),
('الامبراطور','صغير',1.000),('الامبراطور','وسط',1.300),('الامبراطور','كبير',1.600),('الامبراطور','كان',1.600),('الامبراطور','نص لتر',1.600),('الامبراطور','لتر',3.600),('الامبراطور','لتر ونص',4.500),
('عوار قلب','صغير',1.000),('عوار قلب','وسط',1.200),('عوار قلب','كبير',1.500),('عوار قلب','كان',1.600),('عوار قلب','نص لتر',1.600),('عوار قلب','لتر',3.600),('عوار قلب','لتر ونص',4.500),
('فيروز','صغير',0.800),('فيروز','وسط',1.100),('فيروز','كبير',1.500),('فيروز','كان',1.500),('فيروز','نص لتر',1.500),('فيروز','لتر',3.000),('فيروز','لتر ونص',4.000),
('شروق','صغير',0.800),('شروق','وسط',1.100),('شروق','كبير',1.500),('شروق','كان',1.500),('شروق','نص لتر',1.500),('شروق','لتر',3.000),('شروق','لتر ونص',4.000),
('ريلاكس','صغير',0.800),('ريلاكس','وسط',1.100),('ريلاكس','كبير',1.500),('ريلاكس','كان',1.500),('ريلاكس','نص لتر',1.500),('ريلاكس','لتر',3.000),('ريلاكس','لتر ونص',4.000),
('روتانا','صغير',0.800),('روتانا','وسط',1.100),('روتانا','كبير',1.500),('روتانا','كان',1.500),('روتانا','نص لتر',1.500),('روتانا','لتر',3.000),('روتانا','لتر ونص',4.000),
('فرحه','صغير',0.800),('فرحه','وسط',1.100),('فرحه','كبير',1.500),('فرحه','كان',1.500),('فرحه','نص لتر',1.500),('فرحه','لتر',3.000),('فرحه','لتر ونص',4.000),
('جنه','صغير',0.800),('جنه','وسط',1.100),('جنه','كبير',1.500),('جنه','كان',1.500),('جنه','نص لتر',1.500),('جنه','لتر',3.000),('جنه','لتر ونص',4.000),
('بهجه','صغير',0.800),('بهجه','وسط',1.100),('بهجه','كبير',1.500),('بهجه','كان',1.500),('بهجه','نص لتر',1.500),('بهجه','لتر',3.000),('بهجه','لتر ونص',4.000),
('كيان','صغير',0.800),('كيان','وسط',1.100),('كيان','كبير',1.500),('كيان','كان',1.500),('كيان','نص لتر',1.500),('كيان','لتر',3.000),('كيان','لتر ونص',4.000);


INSERT INTO prices (product_name, size, price) VALUES
('مكس باشون','صغير',0.800),('مكس باشون','وسط',1.100),('مكس باشون','كبير',1.500),('مكس باشون','كان',1.500),('مكس باشون','نص لتر',1.500),('مكس باشون','لتر',3.000),('مكس باشون','لتر ونص',4.000),
('زوزو','صغير',0.800),('زوزو','وسط',1.100),('زوزو','كبير',1.500),('زوزو','كان',1.500),('زوزو','نص لتر',1.500),('زوزو','لتر',3.000),('زوزو','لتر ونص',4.000),
('فيتامين جرين','صغير',0.800),('فيتامين جرين','وسط',1.100),('فيتامين جرين','كبير',1.500),('فيتامين جرين','كان',1.500),('فيتامين جرين','نص لتر',1.500),('فيتامين جرين','لتر',3.000),('فيتامين جرين','لتر ونص',4.000),
('جرين ميلون','صغير',0.800),('جرين ميلون','وسط',1.100),('جرين ميلون','كبير',1.500),('جرين ميلون','كان',1.500),('جرين ميلون','نص لتر',1.500),('جرين ميلون','لتر',3.000),('جرين ميلون','لتر ونص',4.000),
('بينك ليمونادا','صغير',0.800),('بينك ليمونادا','وسط',1.100),('بينك ليمونادا','كبير',1.500),('بينك ليمونادا','كان',1.500),('بينك ليمونادا','نص لتر',1.500),('بينك ليمونادا','لتر',3.000),('بينك ليمونادا','لتر ونص',4.000),
('سوبر امبراطور','صغير',1.200),('سوبر امبراطور','وسط',1.400),('سوبر امبراطور','كبير',1.800),
('سوبر عوار قلب','صغير',1.200),('سوبر عوار قلب','وسط',1.400),('سوبر عوار قلب','كبير',1.800),
('افوكادو مانجو','صغير',0.900),('افوكادو مانجو','وسط',1.200),('افوكادو مانجو','كبير',1.400),('افوكادو مانجو','كان',1.800),('افوكادو مانجو','نص لتر',1.800),('افوكادو مانجو','لتر',3.500),('افوكادو مانجو','لتر ونص',4.200),
('بلاك بيري','صغير',0.900),('بلاك بيري','وسط',1.200),('بلاك بيري','كبير',1.400),('بلاك بيري','كان',1.800),('بلاك بيري','نص لتر',1.800),('بلاك بيري','لتر',3.500),('بلاك بيري','لتر ونص',4.200),
('عمده','صغير',0.900),('عمده','وسط',1.200),('عمده','كبير',1.400),('عمده','كان',1.800),('عمده','نص لتر',1.800),('عمده','لتر',3.500),('عمده','لتر ونص',4.200),
('غاليا','صغير',0.900),('غاليا','وسط',1.200),('غاليا','كبير',1.400),('غاليا','كان',1.800),('غاليا','نص لتر',1.800),('غاليا','لتر',3.500),('غاليا','لتر ونص',4.200),
('صاروخ','صغير',1.200),('صاروخ','وسط',1.400),('صاروخ','كبير',1.800),('صاروخ','كان',1.800),('صاروخ','نص لتر',1.800),('صاروخ','لتر',3.800),('صاروخ','لتر ونص',4.600),
('تايجحر','صغير',1.200),('تايجحر','وسط',1.400),('تايجحر','كبير',1.800),('تايجحر','كان',1.800),('تايجحر','نص لتر',1.800),('تايجحر','لتر',3.800),('تايجحر','لتر ونص',4.600),
('افوكادو فراوله','صغير',0.900),('افوكادو فراوله','وسط',1.200),('افوكادو فراوله','كبير',1.400),('افوكادو فراوله','كان',1.800),('افوكادو فراوله','نص لتر',1.500),('افوكادو فراوله','لتر',3.000),('افوكادو فراوله','لتر ونص',4.000),
('افوكادو برتقال اناناس','صغير',0.800),('افوكادو برتقال اناناس','وسط',1.100),('افوكادو برتقال اناناس','كبير',1.500),('افوكادو برتقال اناناس','كان',1.500),('افوكادو برتقال اناناس','نص لتر',1.500),('افوكادو برتقال اناناس','لتر',3.000),('افوكادو برتقال اناناس','لتر ونص',4.000),
('برتقال اناناس','صغير',0.800),('برتقال اناناس','وسط',1.100),('برتقال اناناس','كبير',1.500),('برتقال اناناس','كان',1.500),('برتقال اناناس','نص لتر',1.500),('برتقال اناناس','لتر',3.000),('برتقال اناناس','لتر ونص',4.000);


INSERT INTO prices (product_name, size, price) VALUES
('Rob Mango','صغير',0.900),('Rob Mango','وسط',1.200),('Rob Mango','كبير',1.500),('Rob Mango','كان',1.500),('Rob Mango','نص لتر',1.600),('Rob Mango','لتر',3.000),('Rob Mango','لتر ونص',3.400),
('rob strawberry','صغير',0.900),('rob strawberry','وسط',1.200),('rob strawberry','كبير',1.500),('rob strawberry','كان',1.500),('rob strawberry','نص لتر',1.600),('rob strawberry','لتر',3.000),('rob strawberry','لتر ونص',3.400),
('ROB BERIES','صغير',0.900),('ROB BERIES','وسط',1.200),('ROB BERIES','كبير',1.500),('ROB BERIES','كان',1.500),('ROB BERIES','نص لتر',1.600),('ROB BERIES','لتر',3.000),('ROB BERIES','لتر ونص',3.400),
('ROB PASSION','صغير',0.900),('ROB PASSION','وسط',1.200),('ROB PASSION','كبير',1.500),('ROB PASSION','كان',1.500),('ROB PASSION','نص لتر',1.600),('ROB PASSION','لتر',3.000),('ROB PASSION','لتر ونص',3.400),
('POMEGRANAT ROB','صغير',0.900),('POMEGRANAT ROB','وسط',1.200),('POMEGRANAT ROB','كبير',1.500),('POMEGRANAT ROB','كان',1.500),('POMEGRANAT ROB','نص لتر',1.600),('POMEGRANAT ROB','لتر',3.000),('POMEGRANAT ROB','لتر ونص',3.400),
('ROB DATES','صغير',1.000),('ROB DATES','وسط',1.300),('ROB DATES','كبير',1.600),('ROB DATES','كان',1.600),('ROB DATES','نص لتر',1.900),('ROB DATES','لتر',3.800),('ROB DATES','لتر ونص',4.200);


INSERT INTO prices (product_name, size, price) VALUES
('SHAKE VANILIA','صغير',0.800),('SHAKE VANILIA','وسط',1.100),('SHAKE VANILIA','كبير',1.400),('SHAKE VANILIA','كان',1.500),('SHAKE VANILIA','نص لتر',1.500),('SHAKE VANILIA','لتر',3.000),('SHAKE VANILIA','لتر ونص',4.000),
('SHAKE MALTEZER','صغير',0.800),('SHAKE MALTEZER','وسط',1.100),('SHAKE MALTEZER','كبير',1.400),('SHAKE MALTEZER','كان',1.500),('SHAKE MALTEZER','نص لتر',1.500),('SHAKE MALTEZER','لتر',3.000),('SHAKE MALTEZER','لتر ونص',4.000),
('KETKAT','صغير',0.800),('KETKAT','وسط',1.100),('KETKAT','كبير',1.400),('KETKAT','كان',1.500),('KETKAT','نص لتر',1.500),('KETKAT','لتر',3.000),('KETKAT','لتر ونص',4.000),
('SHAKE KINDER','صغير',0.800),('SHAKE KINDER','وسط',1.100),('SHAKE KINDER','كبير',1.400),('SHAKE KINDER','كان',1.500),('SHAKE KINDER','نص لتر',1.500),('SHAKE KINDER','لتر',3.000),('SHAKE KINDER','لتر ونص',4.000),
('FLAKE','صغير',0.800),('FLAKE','وسط',1.100),('FLAKE','كبير',1.400),('FLAKE','كان',1.500),('FLAKE','نص لتر',1.500),('FLAKE','لتر',3.000),('FLAKE','لتر ونص',4.000),
('GALXY','صغير',0.800),('GALXY','وسط',1.100),('GALXY','كبير',1.400),('GALXY','كان',1.500),('GALXY','نص لتر',1.500),('GALXY','لتر',3.000),('GALXY','لتر ونص',4.000),
('SHAKE LOUTS','صغير',1.100),('SHAKE LOUTS','وسط',1.400),('SHAKE LOUTS','كبير',1.600),('SHAKE LOUTS','كان',1.800),('SHAKE LOUTS','نص لتر',1.800),('SHAKE LOUTS','لتر',3.800),('SHAKE LOUTS','لتر ونص',4.500),
('SHAKE NUTTILA','صغير',0.800),('SHAKE NUTTILA','وسط',1.100),('SHAKE NUTTILA','كبير',1.400),('SHAKE NUTTILA','كان',1.500),('SHAKE NUTTILA','نص لتر',1.500),('SHAKE NUTTILA','لتر',3.000),('SHAKE NUTTILA','لتر ونص',4.000),
('OREO','صغير',0.800),('OREO','وسط',1.100),('OREO','كبير',1.400),('OREO','كان',1.500),('OREO','نص لتر',1.500),('OREO','لتر',3.000),('OREO','لتر ونص',4.000);


INSERT INTO prices (product_name, size, price) VALUES
('nuttela ice cream','صغير',1.400),
('louts ice cream','صغير',1.400),('louts ice cream','وسط',1.600),
('kinder ice cream','صغير',1.400),
('pistachio ice cream','صغير',1.600),
('marbel ice cream','صغير',1.400),
('maltezer ice cream','صغير',1.400),
('mango ice cream','صغير',1.400);



