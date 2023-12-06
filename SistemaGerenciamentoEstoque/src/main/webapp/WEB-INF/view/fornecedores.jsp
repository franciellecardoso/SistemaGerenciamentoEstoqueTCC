<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Fornecedores</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
		<br />
	</div>
	<div>
		<form action="fornecedores" method="post">
			<table>
				<tr>
					<td><input type="submit" value="Listar" id="button"
						name="button" class="bt-listar" style="margin-left: 220px"></td>
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
		<c:if test="${not empty listaFornecedores }">
			<table border=1>
				<thead>
					<tr>
						<th>CNPJ</th>
						<th>Nome</th>
						<th>Telefone</th>
						<th>Email</th>
						<th>CEP</th>
						<th>Logradouro</th>
						<th>Número</th>
						<th>Bairro</th>
						<th>Cidade</th>
						<th>Estado</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="fo" items="${listaFornecedores }">
						<tr class="forn">
							<td>${fo.cnpj }</td>
							<td>${fo.nome }</td>
							<td>${fo.telefone }</td>
							<td>${fo.email }</td>
							<td>${fo.cep }</td>
							<td>${fo.logradouro }</td>
							<td>${fo.numero }</td>
							<td>${fo.bairro }</td>
							<td>${fo.cidade }</td>
							<td>${fo.estado }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>