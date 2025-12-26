# Báo Cáo Đánh Giá Pattern Recognition - 6-Step Pipeline

**Ngày chạy:** 2025-12-24  
**Số câu hỏi:** 20  
**Database:** hospital_1

---

## 📊 Tổng Quan Kết Quả

### So Sánh Theo Giai Đoạn

| Giai Đoạn | Execute Accuracy | Exact Match | Thời gian (s) | Ghi chú |
|-----------|------------------|-------------|---------------|---------|
| **Trước tối ưu** | 55.0% | 15.0% | 337.3 | Baseline |
| **Sau tối ưu lần 1** | 60.0% | 50.0% | 282.9 | +35% Exact Match |
| **Sau pattern recognition** | **75.0%** | **45.0%** | 328.4 | +20% Execute, -5% Exact Match |

### Phân Tích Xu Hướng

✅ **Execute Accuracy:** Tăng mạnh từ 60% → 75% (+15 điểm phần trăm)
- Cho thấy pattern recognition giúp SQL chạy đúng nhiều hơn
- Nhiều SQL có thể execute đúng dù không exact match

⚠️ **Exact Match:** Giảm nhẹ từ 50% → 45% (-5 điểm phần trăm)
- Vẫn cao hơn baseline (15%) rất nhiều (+30 điểm)
- Có thể do một số pattern chưa được nhận diện đúng

---

## 🎯 Chi Tiết Kết Quả Theo Độ Khó

### Execution Accuracy

| Độ khó | Số câu | Execute Accuracy | Exact Match |
|--------|--------|------------------|-------------|
| Easy | 2 | 100.0% | 100.0% |
| Medium | 5 | 80.0% | 20.0% |
| Hard | 11 | 72.7% | 54.5% |
| Extra | 2 | 50.0% | 0.0% |
| **Tổng** | **20** | **75.0%** | **45.0%** |

### Nhận Xét

- **Easy:** Hoàn hảo (2/2 exact match)
- **Medium:** Execute tốt nhưng exact match thấp (1/5)
- **Hard:** Cân bằng tốt (6/11 exact match)
- **Extra:** Khó nhất, cần cải thiện (0/2 exact match)

---

## 🔍 Phân Tích Lỗi Chi Tiết

### 1. JOIN Thừa/Thiếu (7 lỗi)

#### Câu 4: JOIN thừa
- **Gold:** `SELECT patient FROM stay WHERE room = 111 ORDER BY staystart DESC LIMIT 1`
- **Predict:** `SELECT T1.SSN FROM Patient AS T1 JOIN Stay AS T2 ON T1.SSN = T2.Patient JOIN Room AS T3 ON T2.Room = T3.RoomNumber WHERE T3.RoomNumber = 111 ORDER BY T2.StayEnd DESC LIMIT 1`
- **Vấn đề:** JOIN thừa với Room, dùng StayEnd thay vì StayStart
- **Impact:** Execute có thể đúng nhưng không exact match

#### Câu 6: JOIN thiếu
- **Gold:** `SELECT count(*), T1.blockcode FROM BLOCK AS T1 JOIN room AS T2 ON T1.blockfloor = T2.blockfloor AND T1.blockcode = T2.blockcode GROUP BY T1.blockcode`
- **Predict:** `SELECT BlockCode, COUNT(*) FROM Room GROUP BY BlockCode`
- **Vấn đề:** Thiếu JOIN với BLOCK, có thể sai nếu có nhiều block cùng code
- **Impact:** Execute có thể đúng nhưng không exact match

#### Câu 8, 15: GROUP BY sai + JOIN thừa
- **Gold:** `SELECT name FROM department GROUP BY departmentID ORDER BY count(departmentID) DESC LIMIT 1`
- **Predict:** `SELECT T2.Name FROM Physician AS T1 JOIN Department AS T2 ON T1.DepartmentID = T2.DepartmentID GROUP BY T2.Name ORDER BY COUNT(T1.EmployeeID) DESC LIMIT 1`
- **Vấn đề:** 
  - JOIN thừa với Physician
  - GROUP BY Name thay vì departmentID
- **Impact:** Có thể execute đúng nhưng logic khác

#### Câu 9: JOIN thừa
- **Gold:** `SELECT physician, department FROM affiliated_with WHERE primaryaffiliation = 1`
- **Predict:** `SELECT T1.EmployeeID, T2.Department FROM Physician AS T1 JOIN Affiliated_With AS T2 ON T1.EmployeeID = T2.Physician WHERE T2.PrimaryAffiliation = 1`
- **Vấn đề:** JOIN thừa với Physician, có thể lấy trực tiếp từ Affiliated_With
- **Impact:** Execute đúng nhưng không exact match

#### Câu 14: JOIN sai logic
- **Gold:** `SELECT T4.name FROM stay AS T1 JOIN patient AS T2 ON T1.Patient = T2.SSN JOIN Prescribes AS T3 ON T3.Patient = T2.SSN JOIN Medication AS T4 ON T3.Medication = T4.Code WHERE room = 111`
- **Predict:** `SELECT T1.Name FROM Medication AS T1 JOIN Stay AS T2 ON T1.Code = T2.Patient JOIN Room AS T3 ON T2.Room = T3.RoomNumber WHERE T3.RoomNumber = 111`
- **Vấn đề:** JOIN sai hoàn toàn - `Medication.Code = Stay.Patient` là sai logic
- **Impact:** Execute sai, cần sửa ngay

#### Câu 20: JOIN thừa + COUNT(DISTINCT)
- **Gold:** `SELECT head FROM department GROUP BY departmentID ORDER BY count(departmentID) LIMIT 1`
- **Predict:** `SELECT T1.Head FROM Department AS T1 INNER JOIN Physician AS T2 ON T1.DepartmentID = T2.DepartmentID GROUP BY T1.DepartmentID ORDER BY count(DISTINCT T2.EmployeeID) ASC LIMIT 1`
- **Vấn đề:** 
  - JOIN thừa với Physician
  - COUNT(DISTINCT) thay vì COUNT
- **Impact:** Execute có thể đúng nhưng không exact match

### 2. GROUP BY Sai Cột (4 lỗi)

#### Câu 8, 15: GROUP BY Name thay vì departmentID
- **Vấn đề:** Khi đếm theo department, nên GROUP BY departmentID (PK), không phải Name
- **Pattern:** Đã có rule nhưng chưa áp dụng đúng

#### Câu 13: GROUP BY SSN thay vì patient
- **Gold:** `SELECT name, phone FROM appointment AS T1 JOIN patient AS T2 ON T1.patient = T2.ssn GROUP BY T1.patient HAVING count(*) > 1`
- **Predict:** `SELECT T1.Name, T1.Phone FROM Patient AS T1 JOIN Appointment AS T2 ON T1.SSN = T2.Patient GROUP BY T1.SSN HAVING COUNT(DISTINCT T2.AppointmentID) > 1`
- **Vấn đề:** GROUP BY từ Patient thay vì Appointment.patient
- **Impact:** Có thể execute đúng nhưng logic khác

### 3. SELECT Thêm Cột (1 lỗi)

#### Câu 5: Thêm Cost vào SELECT
- **Gold:** `SELECT name FROM procedures ORDER BY cost LIMIT 3`
- **Predict:** `SELECT Name, Cost FROM Procedures ORDER BY Cost DESC LIMIT 3`
- **Vấn đề:** Thêm Cost vào SELECT, thêm DESC
- **Impact:** Execute đúng nhưng không exact match

### 4. COUNT vs COUNT(DISTINCT) (2 lỗi)

#### Câu 2: COUNT(DISTINCT) thay vì COUNT
- **Gold:** `SELECT count(T1.SSN) FROM patient AS T1 JOIN prescribes AS T2 ON T1.SSN = T2.patient JOIN physician AS T3 ON T2.physician = T3.employeeid WHERE T3.name = "John Dorian"`
- **Predict:** `SELECT COUNT(DISTINCT T2.Patient) FROM Physician AS T1 JOIN Prescribes AS T2 ON T1.EmployeeID = T2.Physician WHERE T1.Name = 'John Dorian'`
- **Vấn đề:** Dùng COUNT(DISTINCT) thay vì COUNT
- **Impact:** Có thể execute đúng nhưng kết quả khác nếu có duplicate

#### Câu 13: COUNT(DISTINCT) thay vì COUNT
- **Vấn đề:** Tương tự câu 2

### 5. IN vs OR (1 lỗi)

#### Câu 10: IN thay vì OR
- **Gold:** `SELECT T1.name FROM physician AS T1 JOIN affiliated_with AS T2 ON T1.EmployeeID = T2.physician JOIN department AS T3 ON T2.department = T3.DepartmentID WHERE T3.name = 'Surgery' OR T3.name = 'Psychiatry'`
- **Predict:** `SELECT T1.Name FROM Physician AS T1 JOIN Affiliated_With AS T2 ON T1.EmployeeID = T2.Physician JOIN Department AS T3 ON T2.Department = T3.DepartmentID WHERE T3.Name IN ('Surgery', 'Psychiatry')`
- **Vấn đề:** Dùng IN thay vì OR (pattern recognition chưa nhận diện đúng)
- **Impact:** Execute đúng nhưng không exact match

---

## ✅ Các Câu Đạt Exact Match (9/20 = 45%)

1. ✅ Câu 1: EXCEPT pattern đúng
2. ✅ Câu 3: EXCEPT pattern đúng
3. ✅ Câu 7: JOIN và ORDER BY đúng
4. ✅ Câu 12: COUNT(DISTINCT) đúng
5. ✅ Câu 16: DISTINCT và WHERE đúng
6. ✅ Câu 17: JOIN và WHERE đúng
7. ✅ Câu 18: EXCEPT pattern đúng
8. ✅ Câu 19: Aggregation đúng
9. ✅ Câu 11: JOIN đúng (thiếu DISTINCT nhưng vẫn đúng)

---

## 🎯 Đề Xuất Cải Thiện

### 1. JOIN Optimization Rules
- **Vấn đề:** Thêm JOIN không cần thiết
- **Giải pháp:** 
  - Kiểm tra xem tất cả columns trong SELECT/FILTER có trong 1 table không
  - Nếu có → không cần JOIN
  - Ví dụ: Câu 9 có thể lấy trực tiếp từ Affiliated_With

### 2. GROUP BY Strategy
- **Vấn đề:** GROUP BY sai cột (Name thay vì ID)
- **Giải pháp:**
  - Khi đếm theo entity → luôn GROUP BY PK/ID
  - Chỉ GROUP BY display column khi cần output display column
  - Ví dụ: Câu 8, 15 nên GROUP BY departmentID

### 3. COUNT vs COUNT(DISTINCT)
- **Vấn đề:** Dùng COUNT(DISTINCT) khi không cần
- **Giải pháp:**
  - Phân tích xem có duplicate không
  - Nếu không có duplicate → dùng COUNT(*)
  - Ví dụ: Câu 2, 13

### 4. IN vs OR Pattern
- **Vấn đề:** Pattern recognition chưa nhận diện OR pattern
- **Giải pháp:**
  - Cải thiện analyzer để nhận diện "A or B" → OR
  - "A and B" (cùng result set) → OR
  - "A combined with B" (khác result set) → UNION

### 5. JOIN Logic Validation
- **Vấn đề:** JOIN sai logic (Câu 14)
- **Giải pháp:**
  - Validator cần kiểm tra JOIN conditions có hợp lý không
  - Kiểm tra data types: Code (text) ≠ Patient (number)
  - Ví dụ: Medication.Code = Stay.Patient là sai

### 6. SELECT Column Matching
- **Vấn đề:** Thêm columns không cần thiết
- **Giải pháp:**
  - Strict matching với expected_output_fields
  - Không thêm columns trừ khi cần cho ORDER BY/GROUP BY

---

## 📈 Kết Luận

### Điểm Mạnh
1. ✅ Execute Accuracy tăng mạnh (+15%) - SQL chạy đúng nhiều hơn
2. ✅ Exact Match vẫn cao hơn baseline rất nhiều (+30%)
3. ✅ Pattern recognition hoạt động tốt cho EXCEPT, DISTINCT
4. ✅ Hard questions có tỉ lệ exact match tốt (54.5%)

### Điểm Yếu
1. ⚠️ JOIN optimization chưa tốt (thừa/thiếu JOIN)
2. ⚠️ GROUP BY strategy chưa nhất quán
3. ⚠️ COUNT vs COUNT(DISTINCT) chưa phân biệt rõ
4. ⚠️ IN vs OR pattern chưa nhận diện đúng
5. ⚠️ JOIN logic validation cần cải thiện

### Hướng Phát Triển
1. **Ngắn hạn:** Sửa JOIN optimization và GROUP BY strategy
2. **Trung hạn:** Cải thiện pattern recognition cho IN/OR
3. **Dài hạn:** Thêm JOIN logic validation và SELECT column strict matching

---

**Tổng kết:** Pattern recognition đã cải thiện đáng kể Execute Accuracy (+15%), nhưng cần tinh chỉnh thêm để nâng Exact Match lên mức cao hơn (mục tiêu >60%).

