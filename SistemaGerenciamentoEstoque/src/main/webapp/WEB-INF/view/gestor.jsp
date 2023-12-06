<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Gestor</title>
</head>
<body>
	<div>
		<jsp:include page="menuGestor.jsp" />
		<br />
	</div>
	<div>
		<form action="gestor" method="post">
			<table>
				<tr>
					<td colspan="3"><label for="cpf">CPF</label> <input
						type="text" id="cpf" name="cpf"
						placeholder="Digite o CPF do funcionário"
						value='${funcionario.cpf }'></td>
					<td style="text-align: center"><input type="submit" value="Consultar" id="button"
						name="button" class="bt-consultar"></td>
				</tr>
				<tr>
					<td colspan="4"><label for="nome">Nome</label> <input
						type="text" id="nome" name="nome"
						placeholder="Digite o nome do funcionário"
						value='${funcionario.nome }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="email">Email</label> <input
						type="text" id="email" name="email"
						placeholder="Digite o email do funcionário"
						value='${funcionario.email }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="senha">Senha</label> <input
						type="text" id="senha" name="senha"
						placeholder="Digite a senha do funcionario"
						value='${funcionario.senha }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="cargo">Cargo</label> <input
						type="number" id="cargo" name="cargo" min="0"
						placeholder="Digite o numero do cargo do funcionario"
						value='${funcionario.cargo }'></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center"><input type="submit" value="Cadastrar" id="button"
						name="button" class="bt-cadastrar"></td>
					<td style="text-align: center"><input type="submit" value="Atualizar" id="button"
						name="button" class="bt-atualizar"></td>
					<td style="text-align: center"><input type="submit" value="Listar" id="button"
						name="button" class="bt-listar"></td>
				</tr>
			</table>
		</form>
	</div>
	<div>
		<c:if test="${not empty saida }">
			<p>
				<c:out value="${saida }" />
			</p>
		</c:if>
		<c:if test="${not empty erro }">
			<H2 style="color: red">
				<c:out value="${erro }" />
			</H2>
		</c:if>
	</div>
	<div>
		<br />
		<c:if test="${not empty listaFuncionario }">
			<table border=1>
				<thead>
					<tr>
						<th>CPF</th>
						<th>Nome</th>
						<th>Email</th>
						<th>Senha</th>
						<th>Cargo</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="f" items="${listaFuncionario }">
						<tr class="prod">
							<td>${f.cpf }</td>
							<td>${f.nome }</td>
							<td>${f.email }</td>
							<td>${f.senha }</td>
							<td>${f.cargo }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>