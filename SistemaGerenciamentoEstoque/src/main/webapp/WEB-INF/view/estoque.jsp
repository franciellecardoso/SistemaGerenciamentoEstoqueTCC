<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Estoque</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
		<br />
	</div>
	<div>
		<form action="estoque" method="post">
			<table>
				<tr>
					<td style="text-align: center">
						<p>Verificar por Nível de Estoque</p> <input type="submit"
						value="Por Nivel" id="button" name="button" class="bt-nivel">
					</td>
					<td style="text-align: center">
						<p>Verificar por Data de Vencimento</p> <input type="submit"
						value="Por Vencimento" id="button" name="button" class="bt-venc">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<c:if test="${not empty listaEstoque }">
		<table border="1">
			<thead>
				<tr>
					<th colspan="10" style="text-align: center;">Lista de Produto
						no Estoque</th>
				</tr>
				<tr>
					<th>Código</th>
					<th>Nome</th>
					<th>Vencimento</th>
					<th>Marca</th>
					<th>CNPJ do Fornecedor</th>
					<th>Nome do Fornecedor</th>
					<th>Quantidade em Estoque</th>
					<th>Valor Unitário</th>
					<th>Nível de Estoque</th>
					<th>Valor Total do Item</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="p" items="${listaEstoque }">
					<tr class="est">
						<td>${p.codigo }</td>
						<td>${p.nome }</td>
						<td>${p.vencimento }</td>
						<td>${p.marca}</td>
						<td>${p.cnpjFornecedor }</td>
						<td>${p.nomeFornecedor }</td>
						<td>${p.quantidade}</td>
						<td>${p.valorUnitario }</td>
						<td
							style="background-color: ${p.nivel == 'Sem Estoque' ? 'red' : (p.nivel == 'Estoque Baixo' ? 'orange' : (p.nivel == 'Estoque Moderado' ? 'yellow' : 'green'))};">${p.nivel}</td>
						<td>${p.valorTotal }</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</c:if>
</body>
</html>
