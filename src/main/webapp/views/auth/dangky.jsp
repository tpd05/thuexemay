<%@ page contentType="text/html;charset=UTF-8"%>
<%
String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng Ký</title>

<style>
.hidden {
	display: none;
}

.branch-item {
	border: 1px solid #ccc;
	padding: 10px;
	margin-bottom: 10px;
}
</style>

</head>
<body>

	<h2>Đăng Ký Tài Khoản</h2>

	<form id="f">

		Loại tài khoản: <select name="role" id="roleSelect"
			onchange="updateFormFields()">
			<option value="KHACH_HANG">Khách hàng</option>
			<option value="DOI_TAC">Đối tác</option>
		</select> <br>
		<br> Username: <input name="username" required class="required">
		<br>
		<br> Mật khẩu: <input name="password" type="password" required
			class="required"> <br>
		<br> Họ tên: <input name="hoTen" required class="required">
		<br>
		<br> Số điện thoại: <input name="soDienThoai" required
			class="required"> <br>
		<br> Email: <input name="email" type="email" required
			class="required"> <br>
		<br> Số CCCD: <input name="soCCCD" required class="required">
		<br>
		<br>

		<!-- ĐỐI TÁC -->
		<div id="doiTacFields" class="hidden">
			<h3>--- Thông Tin Chi Nhánh ---</h3>

			<div id="branchContainer"></div>

			<button type="button" onclick="addBranch()">+ Thêm chi nhánh</button>
		</div>

		<br>
		<button type="submit">Đăng Ký</button>

	</form>

	<p id="msg"></p>

	<p>
		<a href="<%=ctxPath%>/dangnhap">Đã có tài khoản? Đăng nhập</a>
	</p>

	<script>

const ctx = '<%=ctxPath%>';
let branchIndex = 0;

function addBranch() {
    const container = document.getElementById('branchContainer');

    const div = document.createElement('div');
    div.className = 'branch-item';

    div.innerHTML = `
        <button type="button" onclick="removeBranch(this)" style="color:red">X</button><br>
        Tên chi nhánh: <input name="tenChiNhanh_${branchIndex}" required class="required"><br><br>
        Địa điểm: <input name="diaDiem_${branchIndex}" required class="required"><br>
    `;

    container.appendChild(div);

    addRequiredStars(); 

    branchIndex++;
}


function removeBranch(btn) {
    const container = document.getElementById('branchContainer');

    if (container.children.length <= 1) {
        alert("Phải có ít nhất 1 chi nhánh!");
        return;
    }

    btn.parentElement.remove();
}


function updateFormFields() {
    const role = document.getElementById('roleSelect').value;
    const doiTacFields = document.getElementById('doiTacFields');

    if (role === 'DOI_TAC') {
        doiTacFields.classList.remove('hidden');

        if (document.getElementById('branchContainer').children.length === 0) {
            addBranch();
        }

    } else {
        doiTacFields.classList.add('hidden');
        document.getElementById('branchContainer').innerHTML = '';
        branchIndex = 0;
    }
}


function addRequiredStars() {
    document.querySelectorAll('.required').forEach(input => {
        if (!input.dataset.starAdded) {
            const star = document.createElement('span');
            star.textContent = ' *';
            star.style.color = 'red';

            input.parentNode.insertBefore(star, input.nextSibling);

            input.dataset.starAdded = "true";
        }
    });
}


document.getElementById('f').onsubmit = async function(e) {
    e.preventDefault();

    const btn = e.target.querySelector('button[type="submit"]');
    btn.disabled = true;

    const res = await fetch(ctx + '/dangky', {
        method: 'POST',
        body: new URLSearchParams(new FormData(e.target))
    });

    const xml = new DOMParser().parseFromString(await res.text(), 'application/xml');

    const status = xml.querySelector('status').textContent;
    const msg    = xml.querySelector('message').textContent;

    const el = document.getElementById('msg');
    el.textContent = msg;
    el.style.color = status === 'success' ? 'green' : 'red';

    if (status === 'success') {
        setTimeout(() => location.href = ctx + '/dangnhap', 1500);
    } else {
        btn.disabled = false;
    }
};

updateFormFields();
addRequiredStars();

</script>

</body>
</html>