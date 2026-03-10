-- ============================================
-- SM Elite Hajj Invoice System - Full Data Export
-- Exported from Lovable Cloud Database
-- ============================================

-- ============================================
-- USERS (Admin user - password will be set during setup)
-- ============================================
INSERT INTO public.users (id, email, password_hash, raw_user_meta_data, email_confirmed_at, created_at)
VALUES (
  'c52a1921-1e7d-4295-98fb-446f8a9575c2',
  'smelitehajj@gmail.com',
  -- This is bcrypt hash for 'Admin123@' - CHANGE THIS AFTER FIRST LOGIN
  '$2a$12$LJ4VFS.ZMz0Yv8aDpZrb0.T7VhgBkQeQa6V8HhA1D5qVp6fKhvYq2',
  '{"full_name": "S M Elite Hajj Limited"}',
  now(),
  '2026-02-05 06:45:24.881229+00'
) ON CONFLICT (id) DO NOTHING;

-- Test user (optional)
INSERT INTO public.users (id, email, password_hash, raw_user_meta_data, email_confirmed_at, created_at)
VALUES (
  'd5eae7af-16d2-42c2-844e-db0200d3c491',
  'testuser@example.com',
  '$2a$12$LJ4VFS.ZMz0Yv8aDpZrb0.T7VhgBkQeQa6V8HhA1D5qVp6fKhvYq2',
  '{"full_name": "Test User"}',
  NULL,
  '2026-02-05 04:59:05.193713+00'
) ON CONFLICT (id) DO NOTHING;

-- ============================================
-- PROFILES
-- ============================================
INSERT INTO public.profiles (id, user_id, full_name, is_approved, created_at, updated_at)
VALUES 
  ('208ba1f8-5bd3-4dc7-b806-bfbd50e04eea', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'S M Elite Hajj Limited', true, '2026-02-05 06:45:24.881229+00', '2026-02-05 06:46:32.257684+00'),
  ('be6db362-d8ae-453b-851a-85d7e16588bf', 'd5eae7af-16d2-42c2-844e-db0200d3c491', 'Test User', false, '2026-02-05 04:59:05.193713+00', '2026-02-05 04:59:05.193713+00')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- USER ROLES
-- ============================================
INSERT INTO public.user_roles (id, user_id, role, created_at)
VALUES ('02d152f1-47ef-4048-8e91-10ccda296e46', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'admin', '2026-02-05 06:46:20.868266+00')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- COMPANIES (logos stored as base64 - they will be imported separately)
-- ============================================
INSERT INTO public.companies (id, user_id, name, tagline, email, phone, address_line1, address_line2, website, thank_you_text, show_qr_code, footer_alignment, created_at, updated_at)
VALUES 
  ('ad7edebd-3c24-40df-9faa-488f40d33a55', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'S M Elite Hajj Limited', 'Excellence in Every Step', 'info@smelitehajj.com', '+8801867666888', 'B-25/4, Al-Baraka Super Market', 'Savar Bazar Bus-Stand, Savar, Dhaka-1340', 'www.smelitehajj.com', 'Thank you for staying with us.', true, 'center', '2026-02-05 06:47:05.67882+00', '2026-02-05 06:47:05.67882+00'),
  ('4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'S M Trade International', NULL, 'info@smtradeint.com', '+8801867666888', NULL, NULL, NULL, 'Thank you for staying with us.', true, 'center', '2026-02-05 10:41:58.916982+00', '2026-02-05 10:41:58.916982+00'),
  ('28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'S M Elite Enterprise', NULL, 'info@smeliteent.com', '+8801867666888', NULL, NULL, NULL, 'Thank you for staying with us.', true, 'center', '2026-02-05 16:23:59.65254+00', '2026-02-05 16:23:59.65254+00')
ON CONFLICT (id) DO NOTHING;

-- NOTE: Company logos are stored as base64 data URIs in the logo_url column.
-- They are very large and included in a separate file: company_logos.sql
-- Run that file after this one to import logos.

-- ============================================
-- INVOICES
-- ============================================
INSERT INTO public.invoices (id, user_id, company_id, invoice_number, client_name, client_email, client_phone, client_address, notes, invoice_date, due_date, subtotal, vat_rate, vat_amount, total_amount, paid_amount, due_amount, status, created_at, updated_at)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'ad7edebd-3c24-40df-9faa-488f40d33a55', 'INV-2026-001', 'Mohammad Rahman', 'rahman@email.com.bd', '+8801712345678', '123 Gulshan Avenue, Dhaka 1212', NULL, '2026-02-01', '2026-02-28', 150000.00, 5.00, 7500.00, 157500.00, 157500.00, 0.00, 'paid', '2026-02-05 06:49:35.46345+00', '2026-02-08 11:04:24.188238+00'),
  ('22222222-2222-2222-2222-222222222222', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'ad7edebd-3c24-40df-9faa-488f40d33a55', 'INV-2026-002', 'Fatima Begum', 'fatima.begum@email.com.bd', '+8801898765432', '45 Banani Road, Dhaka 1213', NULL, '2026-02-03', '2026-03-03', 280000.00, 5.00, 14000.00, 294000.00, 100000.00, 194000.00, 'partial', '2026-02-05 06:49:35.46345+00', '2026-02-05 06:49:35.46345+00'),
  ('33333333-3333-3333-3333-333333333333', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'ad7edebd-3c24-40df-9faa-488f40d33a55', 'INV-2026-003', 'Abdul Karim', 'abdul.karim@email.com.bd', '+8801611223344', '78 Dhanmondi, Dhaka 1205', NULL, '2026-02-05', '2026-03-05', 95000.00, 5.00, 4750.00, 99750.00, 0.00, 99750.00, 'unpaid', '2026-02-05 06:49:35.46345+00', '2026-02-05 06:49:35.46345+00'),
  ('d081a90e-7577-417d-9742-00088522fcc9', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-004', 'Konda Idial School', 'mdsaddamhossain707@email.com', '+8801796262621', 'C65/01, Imandipur, Savar, Dhaka', NULL, '2026-01-15', '2026-02-07', 575000.00, 0.00, 0.00, 575000.00, 2000.00, 573000.00, 'partial', '2026-02-05 10:54:35.773369+00', '2026-02-09 01:35:21.956422+00'),
  ('85501e69-77c4-462e-97bd-9454c3b81b6f', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-005', 'Bangladesh Public Administration Training Centre', NULL, NULL, 'Savar, Dhaka', NULL, '2026-02-05', '2026-02-05', 2850.00, 0.00, 0.00, 2850.00, 0.00, 2850.00, 'unpaid', '2026-02-05 16:38:51.289223+00', '2026-02-05 23:51:22.918119+00'),
  ('3816c622-0bc6-4f18-b0fa-29dd04dd4c84', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-006', 'Test Customer', 'test@example.com', '01712345678', NULL, NULL, '2026-02-05', NULL, 250000.00, 0.00, 0.00, 250000.00, 0.00, 250000.00, 'unpaid', '2026-02-05 23:21:30.09869+00', '2026-02-05 23:21:30.09869+00'),
  ('aa8c2a2f-7898-458c-aefc-b237b55410de', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-007', 'Savar Idial School', 'mdsaddamhossain707@gmail.com', '01700000011', 'Savar', NULL, '2026-02-06', NULL, 70.00, 0.00, 0.00, 70.00, 0.00, 70.00, 'unpaid', '2026-02-06 14:17:16.501099+00', '2026-02-06 14:24:07.720821+00'),
  ('b2ec76a9-413e-4fef-855f-940c96405c9a', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-005', 'Bangladesh Public Administration Training Centre', NULL, '01715602226', 'Savar, Dhaka', NULL, '2026-02-06', NULL, 658350.00, 0.00, 0.00, 658350.00, 0.00, 658350.00, 'unpaid', '2026-02-06 16:47:38.67678+00', '2026-02-06 16:47:38.67678+00'),
  ('66c1eef4-cdf1-4e75-abee-af1952371aad', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-009', 'Shahibag Idial School', 'smelitehajj@gmail.com', '01715602226', 'Sahibag', NULL, '2026-02-07', NULL, 5490000.00, 0.00, 0.00, 5490000.00, 20000.00, 5470000.00, 'partial', '2026-02-07 10:21:54.631462+00', '2026-02-08 05:58:43.946543+00'),
  ('5c7b3e17-d6e7-4f54-b059-9ba9816ce160', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', 'ad7edebd-3c24-40df-9faa-488f40d33a55', 'INV-2026-010', 'Test Client', NULL, NULL, NULL, NULL, '2026-02-07', NULL, 2925000.00, 0.00, 0.00, 2925000.00, 2000000.00, 925000.00, 'partial', '2026-02-07 17:39:46.252995+00', '2026-02-08 10:58:17.417789+00'),
  ('0e4a33ad-ce1c-41b1-9ea4-46825e688a8b', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-011', 'Bangladesh Public Administration Training Centre', NULL, NULL, 'Savar, Dhaka', NULL, '2026-01-26', NULL, 37050.00, 15.00, 5557.50, 42607.50, 0.00, 42607.50, 'unpaid', '2026-02-08 11:39:41.759302+00', '2026-03-08 08:44:54.197032+00'),
  ('0e38391c-70d0-40d2-b8f8-a1c4d919bbad', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '4c19d624-cf7b-48b0-a597-8ba4e7314a6d', 'INV-2026-012', 'Course Director, 79th Foundation Training Course', NULL, NULL, 'Bangladesh Public Administration Training Centre', NULL, '2026-01-21', NULL, 120400.00, 15.00, 18060.00, 138460.00, 0.00, 138460.00, 'unpaid', '2026-02-08 11:50:41.925802+00', '2026-03-08 08:43:27.953897+00'),
  ('3a565796-70f1-4a1c-9778-3febc6e418fa', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-013', 'Khademul Islam Madrasa', 'mdsaddamhossain707@email.com', '+8801796262621', 'Imandipur', NULL, '2026-02-09', NULL, 33000.00, 0.00, 0.00, 33000.00, 10000.00, 23000.00, 'partial', '2026-02-09 02:20:36.98477+00', '2026-02-09 02:20:36.98477+00'),
  ('827bfd3e-6e56-4607-ac70-902f4ceb195f', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-1074', 'Konda Idial School', NULL, '+8801818715732', NULL, NULL, '2026-02-09', NULL, 11200.00, 0.00, 0.00, 11200.00, 10000.00, 1200.00, 'partial', '2026-02-09 04:59:38.693793+00', '2026-02-24 06:29:07.092408+00'),
  ('daf2900c-5c79-4407-92b4-674fdfb8fb6b', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-016', 'PRESIDENCY SCHOOL', NULL, NULL, 'RADIO COLONY, SAVAR, DHAKA', NULL, '2026-02-23', NULL, 8775.00, 0.00, 0.00, 8775.00, 8000.00, 775.00, 'partial', '2026-02-24 06:22:29.445806+00', '2026-03-08 11:11:37.027924+00'),
  ('3acd8c07-1595-4735-8e33-f05e17e7d228', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-015', 'Green Viwe School And Collage', NULL, '+8801712863955', 'Mojidpur, Savar, Dhaka', NULL, '2026-02-24', NULL, 13670.00, 0.00, 0.00, 13670.00, 10000.00, 3670.00, 'partial', '2026-02-24 05:48:17.812778+00', '2026-03-08 08:12:00.118494+00'),
  ('23535edf-a584-41e1-9f30-159bebc83268', 'c52a1921-1e7d-4295-98fb-446f8a9575c2', '28ee11f3-8a14-4b97-adb5-e22cd98230b5', 'INV-2026-017', 'PRESIDENCY SCHOOL', NULL, NULL, NULL, NULL, '2026-03-08', NULL, 52215.00, 0.00, 0.00, 52215.00, 0.00, 52215.00, 'unpaid', '2026-03-08 11:13:12.905772+00', '2026-03-08 11:13:34.25746+00')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- INVOICE ITEMS
-- ============================================
INSERT INTO public.invoice_items (id, invoice_id, title, qty, unit_price, amount, created_at)
VALUES 
  -- INV-2026-001 items
  ('613c05e1-272f-4bd0-9ee0-8ae31c887b66', '11111111-1111-1111-1111-111111111111', 'Hajj Package - Economy', 1, 120000.00, 120000.00, '2026-02-05 06:52:09.183495+00'),
  ('e9a93c76-1870-4065-91c3-73d222f6e51f', '11111111-1111-1111-1111-111111111111', 'Visa Processing Fee', 1, 15000.00, 15000.00, '2026-02-05 06:52:09.183495+00'),
  ('92a76c4f-80b3-4cbb-8c84-517ffe50dfcc', '11111111-1111-1111-1111-111111111111', 'Travel Insurance', 1, 15000.00, 15000.00, '2026-02-05 06:52:09.183495+00'),
  -- INV-2026-002 items
  ('a123ebf8-71ee-403f-bec4-54f641140e03', '22222222-2222-2222-2222-222222222222', 'Umrah Package - Premium', 1, 220000.00, 220000.00, '2026-02-05 06:52:09.183495+00'),
  ('57d633b8-0aa7-442d-a85f-978c4e6e924e', '22222222-2222-2222-2222-222222222222', 'Hotel Upgrade (5-Star)', 1, 40000.00, 40000.00, '2026-02-05 06:52:09.183495+00'),
  ('7b8667b3-bee8-4b44-b2ff-c72c8395566b', '22222222-2222-2222-2222-222222222222', 'Airport Transfer', 1, 20000.00, 20000.00, '2026-02-05 06:52:09.183495+00'),
  -- INV-2026-003 items
  ('f2cb3b43-5f65-4ef2-80ef-a7f1b694da5e', '33333333-3333-3333-3333-333333333333', 'Hajj Package - Standard', 1, 85000.00, 85000.00, '2026-02-05 06:52:09.183495+00'),
  ('b1600c45-5181-4568-a586-798baa07a287', '33333333-3333-3333-3333-333333333333', 'Documentation Fee', 1, 10000.00, 10000.00, '2026-02-05 06:52:09.183495+00'),
  -- INV-2026-005 items
  ('92a6d034-035c-42fd-9072-7123c0155fb7', '85501e69-77c4-462e-97bd-9454c3b81b6f', 'Ring File Folder', 1, 2850.00, 2850.00, '2026-02-05 23:51:24.511542+00'),
  -- INV-2026-006 items
  ('591dbb9e-81f8-4f92-b241-627f86f86945', '3816c622-0bc6-4f18-b0fa-29dd04dd4c84', 'Hajj Package Deluxe', 1, 250000.00, 250000.00, '2026-02-05 23:21:30.323017+00'),
  -- INV-2026-007 items
  ('741d83b6-0010-441f-b2db-fb682f42191e', 'aa8c2a2f-7898-458c-aefc-b237b55410de', 'Note Book', 1, 60.00, 60.00, '2026-02-06 14:24:09.081163+00'),
  ('b9804c32-8785-436f-ac3e-d40b2c5d898c', 'aa8c2a2f-7898-458c-aefc-b237b55410de', 'Pen', 1, 10.00, 10.00, '2026-02-06 14:24:09.081163+00'),
  -- INV-2026-005 (b2ec) items
  ('e583372d-e685-449b-b6a7-586310ce9402', 'b2ec76a9-413e-4fef-855f-940c96405c9a', 'Ring File Folder', 1, 658350.00, 658350.00, '2026-02-06 16:47:39.104365+00'),
  -- INV-2026-009 items
  ('a4861a37-ae65-427b-b47b-89a8a47092d1', '66c1eef4-cdf1-4e75-abee-af1952371aad', 'pen', 100, 1800.00, 180000.00, '2026-02-08 05:58:44.927565+00'),
  ('0efeb92c-d575-4400-a437-dc099b709bb4', '66c1eef4-cdf1-4e75-abee-af1952371aad', 'Note Book', 50, 22200.00, 1110000.00, '2026-02-08 05:58:44.927565+00'),
  ('f96ad59e-ea26-4f95-bede-a223915c0cb0', '66c1eef4-cdf1-4e75-abee-af1952371aad', 'ID Card', 200, 21000.00, 4200000.00, '2026-02-08 05:58:44.927565+00'),
  -- INV-2026-010 items
  ('aa9d74dd-1ae2-4891-adbe-873ec03559c6', '5c7b3e17-d6e7-4f54-b059-9ba9816ce160', 'Hajj Package Premium', 5, 75000.00, 375000.00, '2026-02-08 10:58:18.26995+00'),
  ('d70d6959-07e0-468f-8025-ab88b450a4e1', '5c7b3e17-d6e7-4f54-b059-9ba9816ce160', 'VIP Hajj Package Premium', 3, 850000.00, 2550000.00, '2026-02-08 10:58:18.26995+00'),
  -- INV-2026-004 items
  ('e7700533-32c1-4659-ac1b-9b1f59b803a2', 'd081a90e-7577-417d-9742-00088522fcc9', 'Shoulder', 50, 11500.00, 575000.00, '2026-02-09 01:35:22.922775+00'),
  -- INV-2026-013 items
  ('6c7f7749-bd20-477e-b0ef-7b5397d4590e', '3a565796-70f1-4a1c-9778-3febc6e418fa', 'ID card', 350, 60.00, 21000.00, '2026-02-09 02:20:37.332819+00'),
  ('07fb19a5-a921-4d66-beea-772044681111', '3a565796-70f1-4a1c-9778-3febc6e418fa', 'Ribbon', 400, 30.00, 12000.00, '2026-02-09 02:20:37.332819+00'),
  -- INV-2026-1074 items
  ('b4637c89-2491-4ce0-9d9f-0256efd86aa6', '827bfd3e-6e56-4607-ac70-902f4ceb195f', 'Shoulder', 1120, 10.00, 11200.00, '2026-02-24 06:29:08.197336+00'),
  -- INV-2026-015 items
  ('b21f5398-dd8c-432a-b17f-b6211f2624f7', '3acd8c07-1595-4735-8e33-f05e17e7d228', 'PVC ID CARD', 209, 40.00, 8360.00, '2026-03-08 08:12:01.120601+00'),
  ('d81c0c44-6134-47fb-99be-110f2f43568a', '3acd8c07-1595-4735-8e33-f05e17e7d228', 'SOFT COVER', 198, 15.00, 2970.00, '2026-03-08 08:12:01.120601+00'),
  ('a212bb76-99cd-43cc-8583-eb6cd9ef2e06', '3acd8c07-1595-4735-8e33-f05e17e7d228', 'VIP China Cover', 11, 50.00, 550.00, '2026-03-08 08:12:01.120601+00')
ON CONFLICT (id) DO NOTHING;

-- NOTE: INV-2026-016 and INV-2026-017 items need to be added if they exist
-- INV-2026-011 and INV-2026-012 items need to be checked

-- ============================================
-- INSTALLMENTS
-- ============================================
INSERT INTO public.installments (id, invoice_id, amount, paid_date, payment_method, created_at)
VALUES 
  ('5869f60e-0db2-4f4c-ab73-bf34c892730e', '11111111-1111-1111-1111-111111111111', 157500.00, '2026-02-05', 'Bank Transfer', '2026-02-05 06:52:22.263813+00'),
  ('645cfa25-30d7-4a03-b923-9fe48d8aaa99', '22222222-2222-2222-2222-222222222222', 50000.00, '2026-02-03', 'Bank Transfer', '2026-02-05 06:52:22.263813+00'),
  ('585fdf6a-56b3-4283-80d2-2232d9778fdb', '22222222-2222-2222-2222-222222222222', 50000.00, '2026-02-04', 'Bank Transfer', '2026-02-05 06:52:22.263813+00'),
  ('50c5163d-3ea8-4abd-a3da-cbe456bf445c', '66c1eef4-cdf1-4e75-abee-af1952371aad', 20000.00, '2026-02-07', 'Bank Transfer', '2026-02-08 05:58:45.238367+00'),
  ('f7f46891-45b5-4e80-9f4c-07c803240883', '5c7b3e17-d6e7-4f54-b059-9ba9816ce160', 2000000.00, '2026-02-08', 'Bank Transfer', '2026-02-08 10:58:18.549349+00'),
  ('17da8a31-66a6-4d92-8d04-1ac6961ef719', 'd081a90e-7577-417d-9742-00088522fcc9', 2000.00, '2026-01-15', 'Bank Transfer', '2026-02-09 01:35:23.233537+00'),
  ('8ef1662c-7f17-4db5-9e0e-75049bda30ab', '3a565796-70f1-4a1c-9778-3febc6e418fa', 10000.00, '2026-02-09', 'Bank Transfer', '2026-02-09 02:20:37.642491+00'),
  ('f70010d5-e8a6-40c1-9301-697e7c3d79ff', '827bfd3e-6e56-4607-ac70-902f4ceb195f', 2000.00, '2026-01-06', 'Cash', '2026-02-24 06:29:08.513602+00'),
  ('62380410-3e86-4cf3-bce4-51b51f16cc35', '827bfd3e-6e56-4607-ac70-902f4ceb195f', 8000.00, '2026-02-10', 'Cash', '2026-02-24 06:29:08.513602+00'),
  ('5d3648d6-c529-4c75-87f7-e7c63460b91a', '3acd8c07-1595-4735-8e33-f05e17e7d228', 10000.00, '2026-02-24', 'Cash', '2026-03-08 08:12:01.462427+00'),
  ('76298dc7-7f66-41e5-9eaf-57018c3e17d4', 'daf2900c-5c79-4407-92b4-674fdfb8fb6b', 8000.00, '2026-03-08', 'Cash', '2026-03-08 11:11:38.228022+00')
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- THEME SETTINGS
-- ============================================
INSERT INTO public.theme_settings (id, primary_color, secondary_color, accent_color, header_text_color, invoice_title_color, subtotal_text_color, paid_text_color, balance_bg_color, balance_text_color, table_header_bg, table_header_text, border_color, badge_paid_color, badge_partial_color, badge_unpaid_color, footer_text_color)
VALUES (
  '00000000-0000-0000-0000-000000000001',
  '#1e3a8a', '#f3f4f6', '#0f766e', '#1e3a8a', '#1e3a8a', '#374151', '#15803d',
  '#166534', '#ffffff', '#f9fafb', '#374151', '#e5e7eb', '#16a34a', '#f59e0b', '#dc2626', '#6b7280'
)
ON CONFLICT (id) DO UPDATE SET
  primary_color = EXCLUDED.primary_color,
  secondary_color = EXCLUDED.secondary_color,
  accent_color = EXCLUDED.accent_color;

-- ============================================
-- GLOBAL BRAND SETTINGS
-- ============================================
INSERT INTO public.global_brand_settings (id, company_name, tagline, address_line1, address_line2, phone, email, website, thank_you_text, show_qr_code, footer_alignment)
VALUES (
  '00000000-0000-0000-0000-000000000002',
  'S M Elite Hajj Limited',
  'Excellence in Every Step',
  'B-25/4, Al-Baraka Super Market',
  'Savar Bazar Bus-Stand, Savar, Dhaka-1340',
  '+8801867666888',
  'info@smelitehajj.com',
  'Website : smelitehajj.com',
  'Thank you for staying with us.',
  true,
  'center'
)
ON CONFLICT (id) DO UPDATE SET
  company_name = EXCLUDED.company_name,
  tagline = EXCLUDED.tagline;

-- ============================================
-- DATA IMPORT COMPLETE
-- ============================================
