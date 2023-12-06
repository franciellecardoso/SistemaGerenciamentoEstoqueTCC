<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Produto</title>
</head>
<body>
	<div>
		<jsp:include page="menu.jsp" />
		<br />
	</div>
	<div>
		<form action="produto" method="post">
			<table>
				<tr>
					<td colspan="3"><label for="codigo">Código do Produto</label>
						<input type="number" id="codigo" name="codigo"
						placeholder="Digite o código do produto"
						value='${produto.codigo }'></td>
					<td><input type="submit" value="Consultar" id="button"
						name="button" class="bt-consultar"></td>
				</tr>
				<tr>
					<td colspan="4"><label for="nome">Nome</label> <input
						type="text" id="nome" name="nome"
						placeholder="Digite o nome do produto" value='${produto.nome }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="quantidade">Quantidade</label> <input
						type="number" id="quantidade" name="quantidade" min="0" max="50"
						placeholder="Quantidade" value='${produto.quantidade }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="vencimento">Vencimento</label> <input
						type="date" id="vencimento" name="vencimento"
						placeholder="Selecione a data de vencimento do produto"
						value='${produto.vencimento }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="marca">Marca</label> <input
						type="text" id="marca" name="marca"
						placeholder="Digite a marca do produto" value='${produto.marca }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="categoria">Categoria</label> <input
						type="text" id="categoria" name="categoria"
						placeholder="Digite a categoria do produto"
						value='${produto.categoria }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="cnpjFornecedor">CNPJ do
							Fornecedor</label> <input type="text" id="cnpjFornecedor"
						name="cnpjFornecedor" placeholder="Digite o CNPJ do fornecedor"
						value='${produto.cnpjFornecedor }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="nomeFornecedor">Nome do
							Fornecedor</label> <input type="text" id="nomeFornecedor"
						name="nomeFornecedor" placeholder="Digite o nome do fornecedor"
						value='${produto.nomeFornecedor }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="dataCompra">Data de Compra</label>
						<input type="date" id="dataCompra" name="dataCompra"
						placeholder="Selecione a data de compra"
						value='${produto.dataCompra }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="valorUnitario">Valor
							Unitário (R$) Unitário</label> <input type="number" step="0.01"
						id="valorUnitario" name="valorUnitario"
						placeholder="Digite o valor unitário (Ex: 1.99)"
						value='${produto.valorUnitario }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="descricao">Descrição do
							produto</label> <input type="text" id="descricao" name="descricao"
						placeholder="Digite uma descrição clara do produto"
						value='${produto.descricao }'></td>
				</tr>
				<tr>
					<td><input type="submit" value="Cadastrar" id="button"
						name="button" class="bt-cadastrar"></td>
					<td><input type="submit" value="Atualizar" id="button"
						name="button" class="bt-atualizar"></td>
					<td><input type="submit" value="Excluir" id="button"
						name="button" class="bt-excluir"></td>
					<td><input type="submit" value="Listar" id="button"
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
		<c:if test="${not empty listaProdutos }">
			<table border=1>
				<thead>
					<tr>
						<th>Código</th>
						<th>Nome</th>
						<th>Quantidade</th>
						<th>Vencimento</th>
						<th>Marca</th>
						<th>Categoria</th>
						<th>CNPJ Fornecedor</th>
						<th>Nome Fornecedor</th>
						<th>Data de Compra</th>
						<th>Valor Unitário</th>
						<th>Descrição</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="p" items="${listaProdutos }">
						<tr class="prod">
							<td>${p.codigo }</td>
							<td>${p.nome }</td>
							<td>${p.quantidade }</td>
							<td>${p.vencimento }</td>
							<td>${p.marca }</td>
							<td>${p.categoria }</td>
							<td>${p.cnpjFornecedor }</td>
							<td>${p.nomeFornecedor }</td>
							<td>${p.dataCompra }</td>
							<td>${p.valorUnitario }</td>
							<td>${p.descricao }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</c:if>
	</div>
</body>
</html>