<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<link rel="icon" type="image/png" sizes="32x32"
	href="images/icon/favicon-32x32.png">
	    <style>
        .input-form {
            max-width: 600px;
            margin-top: 80px;
            padding: 32px;
            background: #fff;
            -webkit-border-radius: 10px;
            -moz-border-radius: 10px;
            border-radius: 10px;
            -webkit-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
            -moz-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
            box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15)
        }
    </style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>
	$(document).ready(function() {
		//새비번 에 유효성검사 주기. 
		$("#newpw2").on("click", function(){
			var newpw=$("#newpw").val();
			var numAlphabet=/[a-zA-Z].*\d|\d.*[a-zA-Z]/;
			var specialChar=/[!@#$%^&*]/;
			var isVaild = (newpw.length>=8) && numAlphabet.test(newpw) && specialChar.test(newpw);
			
			//newpw가 조건에 맞지않은경우 newpw2에 못쓰게끔.
			if(!isVaild){
				alert("비밀번호는 영문 숫자 특수문자를 포함한 8자리 이상입니다.");
				$("#newpw").focus();
			}
		});

		
		
		//새비번 확인 이 새비번 과 일치하게 썼는지.
		$("#newpw2").on("keyup", function() {
			var newpw = $("#newpw").val();
			var newpw2 = $("#newpw2").val();
			var mesg = "비밀번호가 다릅니다.";

			if (newpw == newpw2) {
				mesg = "비밀번호가 일치합니다.";
			}
			$("#pwcheck").text(mesg);
		});
		
		
	});
	function submitCheck(){
		//비번확인이 동일한경우에만 submit되게끔함. 
		var pwCheck=$("#pwcheck").text();
		if(pwCheck==="비밀번호가 다릅니다."){
			alert("비밀번호가 일치하지 않습니다.");
			return false;
		}
		return true;
	};
</script>
</head>
<body>
	<jsp:include page="../common/nav.jsp" flush="true"/> 
<body>


	<div class="container">
		<div class="input-form-background row">
			<div class="input-form col-md-6 mx-auto">
				<h3>비밀번호 변경</h3>
				<form action="pwchange" method="post" onsubmit="return submitCheck();">
					<div class="input-group mb-3">
						<span class="input-group-text col-4" >현재 비밀번호</span> 
						<input
							type="password" class="form-control" required id="currpw"
							name="currpw" aria-label="Sizing example input"
							aria-describedby="inputGroup-sizing-default">
					</div>
					<div class="input-group mb-3">
						<span class="input-group-text col-4">새 비밀번호</span> 
						<input
							type="password" class="form-control" required id="newpw"
							name="newpw" aria-label="Sizing example input"
							aria-describedby="inputGroup-sizing-default"
							placeholder="영문 숫자 특수문자를 포함한 8자리이상">
					</div>
					<div class="input-group ">
						<span class="input-group-text col-4" >새 비밀번호 확인</span> 
						<input
							type="password" class="form-control" required id="newpw2"
							name="newpw2" aria-label="Sizing example input"
							aria-describedby="inputGroup-sizing-default">
					</div>
					<div style="float:right">
							<strong><span class="" style="color:green" id="pwcheck"></span></strong>
					</div><br><br>
            <div class="d-flex justify-content-center" >
                <button class="btn btn-primary" style="width:30%" id="change" >변경하기</button>
            </div>
            </form>
            
			</div>
		</div>
	</div>
</body>
</html>