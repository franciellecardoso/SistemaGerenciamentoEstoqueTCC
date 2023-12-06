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
		<jsp:include page="menuGestor.jsp" />
		<br />
	</div>
	<div>
		<form action="gestorFornecedor" method="post">
			<table>
				<tr>
					<td colspan="3"><label for="cnpj">CNPJ</label> <input
						type="text" id="cnpj" name="cnpj"
						placeholder="Digite o CNPJ do fornecedor"
						value='${fornecedores.cnpj }'></td>
					<td><input type="submit" value="Consultar" id="button"
						name="button" class="bt-consultar"></td>
				</tr>
				<tr>
					<td colspan="4"><label for="nome">Nome</label> <input
						type="text" id="nome" name="nome"
						placeholder="Digite o nome do fornecedor"
						value='${fornecedores.nome }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="telefone">Celular</label> <input
						type="text" id="telefone" name="telefone"
						placeholder="Digite o celular do fornecedor"
						value='${fornecedores.telefone }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="email">Email</label> <input
						type="text" id="email" name="email"
						placeholder="Digite o email do fornecedor"
						value='${fornecedores.email }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="cep">CEP</label> <input
						type="text" id="cep" name="cep"
						placeholder="Digite o CEP do fornecedor"
						value='${fornecedores.cep }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="logradouro">Logradouro</label> <input
						type="text" id="logradouro" name="logradouro"
						placeholder="Digite o logradouro do fornecedor"
						value='${fornecedores.logradouro }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="numero">Número</label> <input
						type="number" id="numero" name="numero" min="0"
						placeholder="Digite o número do logradouro do fornecedor"
						value='${fornecedores.numero }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="bairro">Bairro</label> <input
						type="text" id="bairro" name="bairro"
						placeholder="Digite o bairro do fornecedor"
						value='${fornecedores.bairro }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="cidade">Cidade</label> <input
						type="text" id="cidade" name="cidade"
						placeholder="Digite a cidade do fornecedor"
						value='${fornecedores.cidade }'></td>
				</tr>
				<tr>
					<td colspan="4"><label for="estado">Estado</label> <input
						type="text" id="estado" name="estado"
						placeholder="Digite o estado do fornecedor"
						value='${fornecedores.estado }'></td>
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