<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"
	href='<c:url value="./resources/css/styles.css" />'>
<meta charset="ISO-8859-1">
<title>Inventory Tracker | Relat�rio</title>
</head>
<body>
	<div align="center">
		<div>
			<jsp:include page="menuGestor.jsp" />
			<br />
		</div>
		<form action="gestorGeraRelatorio" method="post" target="_blank">
			<table>
				<tr>
					<td colspan="4" align="center">Digite o intervalo de datas
						para o relat�rio de An�lise de Vig�ncia de Produtos</td>
				</tr>
				<tr>
					<td>Per�odo:</td>
					<td>De: <input type="text" id="vencimento" name="vencimento"
						placeholder="Vencimento (Ex: dd/MM/yyyy)"></td>
					<td>At�: <input type="text" id="outroVencimento"
						name="outroVencimento" placeholder="Vencimento (Ex: dd/MM/yyyy)"></td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<button type="submit" id="botao" name="botao" value="Gerar"
							class="custom-button">Gerar Relat�rio</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<br />
	<br />
	<div align="center">
		<c:if test="${not empty erro }">
			<H2>
				<c:out value="${erro }" />
			</H2>
		</c:if>
	</div>
</body>
</html>