<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Login</title>
</head>
<body>
	<div class="painel">
		<h5>INVENTORY TRACKER</h5>
		<div class="loginform">
			<h1 style="color: #3498db;">Olá! Seja Bem Vindo(a)!</h1>
			<h3>Efetue o login para continuar</h3>

			<form action="index" method="post">
				<div class="loginemail">
					<label for="email" class="lbl">Email</label> <input class="inputlogin"
						type="text" id="email" name="email" placeholder="Digite seu email">
				</div>
				<div class="loginsenha">
					<label for="senha" class="lbl">Senha</label> <input class="inputlogin"
						type="password" id="senha" name="senha"
						placeholder="Digite sua senha"> <i class="fas fa-eye"
						onclick="mostrarSenha()" id="eyeIcon"></i>
				</div>
				<input type="submit" id="btn" name="btn" value="Entrar">
			</form>
		</div>
	</div>

	<script>
		function mostrarSenha() {
			var senhaInput = document.getElementById("senha");
			if (senhaInput.type === "password") {
				senhaInput.type = "text";
			} else {
				senhaInput.type = "password";
			}
		}
	</script>
</body>
</html>