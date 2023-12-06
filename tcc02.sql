CREATE DATABASE tcc02
GO 
USE tcc02
GO
CREATE TABLE usuario(
email	VARCHAR(100)       NOT NULL,
senha	VARBINARY(64)      NOT NULL, 
tipo	CHAR(1)
PRIMARY KEY (email)
)
GO
CREATE TABLE cargo(
id         INT              NOT NULL,
nome       VARCHAR(20)      NOT NULL
PRIMARY KEY (id)
)
GO
CREATE TABLE funcionario(
cpf		   CHAR(11)	CHECK(LEN (cpf)= 11)	    NOT NULL,
nome	   VARCHAR(100)	    NOT NULL,
email	   VARCHAR(100)	    NOT NULL,
senha	   VARCHAR(10)		NOT NULL,
cargo	   INT		        NOT NULL
PRIMARY KEY (cpf)
FOREIGN KEY (cargo) REFERENCES cargo (id)
)
GO
CREATE TABLE gestor(
cpf			CHAR(11) CHECK(LEN (cpf)= 11) NOT NULL,
nome		VARCHAR(100)				  NOT NULL,
email		VARCHAR(100)				  NOT NULL,
cargo		INT							  NOT NULL,
senha		VARCHAR(50)                   NOT NULL
PRIMARY KEY(cpf)
FOREIGN KEY (cargo) REFERENCES cargo (id)
)
GO
CREATE TABLE fornecedor(
cnpj            CHAR(14)  	CHECK(LEN (cnpj)= 14)				NOT NULL,
nome            VARCHAR(100)   									NOT NULL,
telefone        CHAR(11)              							NOT NULL,
email			VARCHAR(100)									NOT NULL,
cep             CHAR(8)               							NOT NULL,
logradouro      VARCHAR(100)   									NOT NULL,
numero          INT               								NOT NULL,
bairro			VARCHAR(50)										NOT NULL,
cidade			VARCHAR(50)										NOT NULL,
estado			VARCHAR(2)										NOT NULL
PRIMARY KEY (cnpj)	
)

GO
CREATE TABLE produto(
codigo				INT              NOT NULL,
nome				VARCHAR(100)     NOT NULL,
quantidade			VARCHAR(100)     NOT NULL,
vencimento			DATE             NOT NULL, 
marca				VARCHAR(30)      NOT NULL,
categoria			VARCHAR(50)      NOT NULL,
cnpjFornecedor		CHAR(14)		 NOT NULL,
nomeFornecedor		VARCHAR(100)	 NOT NULL,
dataCompra			DATE             NOT NULL,
valorUnitario		DECIMAL(7,2)     NOT NULL,
descricao			VARCHAR(100)     NOT NULL
PRIMARY KEY (codigo),
FOREIGN KEY (cnpjFornecedor) REFERENCES fornecedor (cnpj)
)

GO
INSERT INTO cargo VALUES (1, 'Gestor'), (2, 'Estoquista'), (3, 'Atendente')

SELECT * FROM cargo
SELECT * FROM funcionario
SELECT * FROM usuario

-- DECLARANDO SENHA E INSERINDO GESTOR
GO
DECLARE @senha VARCHAR(50) = '123456'
DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha)
GO
INSERT INTO Gestor (cpf, nome, email, cargo, senha)
VALUES ('28020830820', 'Letícia Aurora Aragão', 'gestora@it.com', 1,'123456')

SELECT * FROM gestor
--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (GESTOR) -------------------------------------------
--Procedure que cria os usuarios do sistema
GO
CREATE PROCEDURE sp_criptografaSenha(@email VARCHAR(50), @senha VARCHAR(50), @tipo CHAR(1))
AS
	DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha)
BEGIN
	INSERT INTO usuario VALUES(@email, @senha_hash, @tipo)
END

--function que valida o login
GO
CREATE FUNCTION fn_validaLogin(@email VARCHAR(100), @senha VARCHAR(50))
RETURNS @login TABLE  (
tipo CHAR(1)
)
AS
BEGIN
	DECLARE @senha_hash VARBINARY(64) = HASHBYTES('SHA2_256', @senha),
			@tipo CHAR(1)
	
	SET @tipo = (SELECT tipo FROM usuario WHERE email = @email AND senha = @senha_hash)

	INSERT INTO @login VALUES (@tipo)
RETURN
END

SELECT * FROM fn_validaLogin('gestora@it.com', '123456')

INSERT INTO usuario (email, senha, tipo)
VALUES ('gestora@it.com', HASHBYTES('SHA2_256', '123456'), 'G');


--------------------------------------------------- PROCEDURES E FUNÇÕES (GESTOR) ---------------------------------------------
--Procedure gestor mantendo funcionarios (CREATE, UPDATE, DELETE) ok
GO
CREATE PROCEDURE sp_manter_funcionario(@opcao CHAR(1), @cpf CHAR(11), @nome VARCHAR(100), @email VARCHAR(100), @senha VARCHAR(10), @cargo INT, @saida VARCHAR(255) OUTPUT
)
AS
BEGIN
	IF (UPPER(@opcao) = 'D'  AND @cpf IS NOT NULL AND @email IS NOT NULL)
	BEGIN
	    DELETE FROM usuario WHERE email = @email
		DELETE FROM funcionario WHERE cpf = @cpf
		SET @saida = 'Funcionário com o CPF: ' + CAST(@cpf AS VARCHAR(15)) + ' excluído'
	END	
	ELSE
	BEGIN
		IF (UPPER(@opcao) = 'D' AND @cpf IS NULL)
		BEGIN
			RAISERROR('Funcionário não encontrado', 16, 1)
		END
		ELSE
		BEGIN
			IF (UPPER(@opcao) = 'I')
			BEGIN

				INSERT INTO funcionario (cpf, nome, email, senha, cargo )
				VALUES (@cpf, @nome, @email, @senha, @cargo)
        
				EXEC sp_criptografaSenha @email, @senha, 'F'

				SET @saida = 'Funcionário cadastrado'
			END
			ELSE
		BEGIN
		IF (UPPER(@opcao) = 'U')
			BEGIN
			UPDATE Funcionario
			SET cpf = @cpf, nome = @nome, email = @email, senha = @senha, cargo = @cargo
			WHERE cpf = @cpf

			 DELETE FROM usuario WHERE email = @email

			 EXEC sp_criptografaSenha @email, @senha, 'F'
          
			SET @saida = 'Funcionário com o CPF: ' + CAST(@cpf AS VARCHAR(15)) + ' atualizado'
			END
		ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END

-- TESTANDO A PROCEDURE ACIMA OK
GO
DECLARE @saida1 VARCHAR(MAX)
DECLARE @senha VARCHAR(50) = '123456'
EXEC sp_manter_funcionario 'I', '18733473838', 'Raul Oliver Cavalcanti', 'raulcavalcanti@it.com', @senha, '3', @saida1 OUTPUT

PRINT @saida1

SELECT f.cpf, f.nome, f.email, f.senha, c.id AS codigo, c.nome AS nomeCargo
FROM funcionario f
INNER JOIN cargo c ON f.cargo = c.id

--SELECT COM MÁSCARA NO CPF
SELECT RTRIM(SUBSTRING(cpf, 1, 3)) + '.' + RTRIM(SUBSTRING(cpf, 4, 3)) + '.' + RTRIM(SUBSTRING(cpf, 7, 3)) + '-' + RTRIM(SUBSTRING(cpf, 10, 2)) AS CPF,
    nome, email, senha, cargo
FROM funcionario

--Function gestor listando funcionários (READ)
GO
CREATE FUNCTION fn_listarfuncionario()
RETURNS @table table(
cpf CHAR(11),
nome VARCHAR(100),
email VARCHAR(100),
senha VARCHAR(100),
cargo INT
)
AS
BEGIN
	INSERT INTO @table (cpf, nome, email, senha, cargo)
	SELECT f.cpf, f.nome, f.email, f.senha, f.cargo FROM funcionario f
	ORDER BY f.nome ASC 
RETURN
END

--SELECT COM MASCARA NO CPF ok
SELECT RTRIM(SUBSTRING(cpf, 1, 3)) + '.' + RTRIM(SUBSTRING(cpf, 4, 3)) + '.' + RTRIM(SUBSTRING(cpf, 7, 3)) + '-' + RTRIM(SUBSTRING(cpf, 10, 2)) AS CPF,
    nome, email, REPLICATE('*', LEN(senha)) AS senha, cargo
FROM fn_listarfuncionario()
ORDER BY nome

--Function gestor pesquisando funcionário por CPF (SEARCH) ok
GO
CREATE FUNCTION fn_pesquisarfuncionario(@cpf CHAR(11))
RETURNS @table table(
cpf CHAR(14),
nome VARCHAR(100),
email VARCHAR(100),
cargo INT
)
AS
BEGIN
	INSERT INTO @table (cpf, nome, email, cargo)
	SELECT RTRIM(SUBSTRING(f.cpf, 1, 3)) + '.' + RTRIM(SUBSTRING(f.cpf, 4, 3)) + '.' + RTRIM(SUBSTRING(f.cpf, 7, 3)) + '-' + RTRIM(SUBSTRING(f.cpf, 10, 2)), f.nome, f.email, f.cargo FROM funcionario f
	WHERE f.cpf = @cpf
	ORDER BY f.nome ASC
RETURN
END

--SELECT DE PESQUISA COM MÁSCARA NO CPF
SELECT * FROM fn_pesquisarfuncionario('18733473838')

--Function gestor pesquisando funcionário por nome ok
GO
CREATE FUNCTION fn_buscarfuncionario(@nome VARCHAR(100))
RETURNS @table table(
cpf CHAR(14),
nome VARCHAR(100),
email VARCHAR(100),
cargo INT
)
AS
BEGIN
	INSERT INTO @table (cpf, nome, email, cargo)
	SELECT RTRIM(SUBSTRING(f.cpf, 1, 3)) + '.' + RTRIM(SUBSTRING(f.cpf, 4, 3)) + '.' + RTRIM(SUBSTRING(f.cpf, 7, 3)) + '-' + RTRIM(SUBSTRING(f.cpf, 10, 2)), f.nome, f.email, f.cargo FROM funcionario f
	WHERE f.nome LIKE '%' + @nome + '%'
	ORDER BY f.nome ASC
RETURN
END

--SELECT DE PESQUISA COM MÁSCARA NO CPF
SELECT * FROM fn_buscarfuncionario('Raul')


--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (FUNCIONÁRIO) -------------------------------------------
--Procedure funcionário mantendo fornecedor (CREATE, UPDATE, DELETE)
GO
CREATE PROCEDURE sp_manter_fornecedor(@opcao CHAR(1), @cnpj CHAR(14), @nome VARCHAR(100), @telefone CHAR(11), @email VARCHAR(100), @cep CHAR(8), @logradouro VARCHAR(100), @numero INT, @bairro VARCHAR(50), @cidade VARCHAR(50), @estado VARCHAR(2), @saida VARCHAR(255) OUTPUT
)
AS
BEGIN
	IF (UPPER(@opcao) = 'D' AND @cnpj IS NOT NULL)
	BEGIN
		DELETE FROM fornecedor WHERE cnpj = @cnpj
		SET @saida = 'Fornecedor com o cnpj: ' + CAST(@cnpj AS VARCHAR(13)) + ' excluído'
	END
	ELSE
	BEGIN
		IF (UPPER(@opcao) = 'D' AND @cnpj IS NULL)
		BEGIN
			RAISERROR('Fornecedor não encontrado', 16, 1)
		END
		ELSE
		BEGIN
			IF (UPPER(@opcao) = 'I')
			BEGIN

				INSERT INTO fornecedor(cnpj, nome, telefone, email, cep, logradouro, numero, bairro, cidade, estado )
				VALUES (@cnpj, @nome, @telefone, @email, @cep, @logradouro, @numero, @bairro, @cidade, @estado)
        
				SET @saida = 'Fornecedor cadastrado'
			END
			ELSE
		BEGIN
		IF (UPPER(@opcao) = 'U')
			BEGIN
			UPDATE fornecedor
			SET cnpj = @cnpj, nome = @nome, telefone = @telefone, email = @email, cep = @cep, logradouro = @logradouro, numero = @numero, bairro = @bairro, cidade = @cidade, estado = @estado
			WHERE cnpj = @cnpj
          
			SET @saida = 'Fornecedor com o CNPJ: ' + CAST(@cnpj AS VARCHAR(15)) + ' atualizado'
			END
		ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END

GO
DECLARE @saida1 VARCHAR(MAX)
EXEC sp_manter_fornecedor 'I', '37207672000182', 'Andreia e Bento Comercio de Bebidas ME', '11987956257', 'administracao@aebcbme.com.br', '08830400', 'Rua Antônio Santos Gonçalves', 382, 'Vila Nova Aparecida', 'Mogi das Cruzes', 'SP', @saida1 OUTPUT
PRINT @saida1
GO
DECLARE @saida2 VARCHAR(MAX)
EXEC sp_manter_fornecedor 'I', '84615822000177', 'Gabriel e Jaqueline Alimentos Ltda', '11983034770', 'qualidade@gjdsaltda.com.br', '08020370', 'Rua Pascoal Daniel', 870, 'Vila Giordano', 'São Paulo', 'SP', @saida2 OUTPUT
PRINT @saida2
GO
DECLARE @saida3 VARCHAR(MAX)
EXEC sp_manter_fornecedor 'I', '10181538000101', 'Claudia e Maya Laticinios Ltda', '11984423225', 'cobranca@claudiaemayaltda.com.br', '06702650', 'Rua Yuri Peixoto', 684, 'Lageado', 'Cotia', 'SP', @saida3 OUTPUT
PRINT @saida3
GO
DECLARE @saida3 VARCHAR(MAX)
EXEC sp_manter_fornecedor 'I', '11256855000102', 'CRYSTAL INDUSTRIA E COMERCIO DE BEBIDAS E ALIMENTOS LTDA', '11984423225', 'cobranca@claudiaemayaltda.com.br', '06702650', 'Rua Yuri Peixoto', 684, 'Lageado', 'Cotia', 'SP', @saida3 OUTPUT
PRINT @saida3
/* comentei para não confundir
--SELECT COM MÁSCARA NO CNPJ, telefone e cep
SELECT RTRIM(SUBSTRING(cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpj, 13, 2)) AS CNPJ,
	nome, 
    CONCAT('(', SUBSTRING(telefone, 1, 2), ') ', SUBSTRING(telefone, 3, 5), '-', SUBSTRING(telefone, 8, 4)) AS  telefone,
	email, 
	RTRIM(SUBSTRING(cep, 1, 5)) + '-' + RTRIM(SUBSTRING(cep,6,3)) AS cep, 
		   logradouro, numero, bairro, cidade, estado
FROM fornecedor
*/

--Function listando fornecedores (READ)
GO
CREATE FUNCTION fn_listarfornecedor()
RETURNS @table table(
cnpj CHAR(14),  					
nome VARCHAR(100),   			
telefone CHAR(11),              	
email VARCHAR(100),			
cep CHAR(8),               		
logradouro VARCHAR(100),   				
numero INT,               			
bairro VARCHAR(50),					
cidade VARCHAR(50),					
estado VARCHAR(2)	
)
AS
BEGIN
	INSERT INTO @table (cnpj, nome, telefone, email, cep, logradouro, numero, bairro, cidade, estado)
	SELECT fo.cnpj, fo.nome, fo.telefone, fo.email, fo.cep, fo.logradouro, fo.numero, fo.bairro, fo.cidade, fo.estado FROM fornecedor fo
	ORDER BY fo.nome 
RETURN
END

--SELECT LISTANDO COM MÁSCARA NO CNPJ, telefone e cep (READ)
SELECT RTRIM(SUBSTRING(cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpj, 13, 2)) AS CNPJ,
	nome, 
    CONCAT('(', SUBSTRING(telefone, 1, 2), ') ', SUBSTRING(telefone, 3, 5), '-', SUBSTRING(telefone, 8, 4)) AS  telefone,
	email, 
	RTRIM(SUBSTRING(cep, 1, 5)) + '-' + RTRIM(SUBSTRING(cep,6,3)) AS cep, 
	logradouro, numero, bairro, cidade, estado
FROM fn_listarfornecedor()
ORDER BY nome

--Function gestor pesquisando fornecedor por CNPJ
GO
CREATE FUNCTION fn_pesquisarfornecedor(@cnpj CHAR(14))
RETURNS @table table(
cnpj CHAR(18),  					
nome VARCHAR(100),   			
telefone CHAR(15),              	
email VARCHAR(100),			
cep CHAR(9),               		
logradouro VARCHAR(100),   				
numero INT,               			
bairro VARCHAR(50),					
cidade VARCHAR(50),					
estado VARCHAR(2)	
)
AS
BEGIN
	INSERT INTO @table (cnpj, nome, telefone, email, cep, logradouro, numero, bairro, cidade, estado)
	SELECT RTRIM(SUBSTRING(fo.cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(fo.cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(fo.cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(fo.cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(fo.cnpj, 13, 2)) AS CNPJ, 
	fo.nome, 
	CONCAT('(', SUBSTRING(fo.telefone, 1, 2), ') ', SUBSTRING(fo.telefone, 3, 5), '-', SUBSTRING(fo.telefone, 8, 4)) AS  telefone, 
	fo.email, 
	RTRIM(SUBSTRING(fo.cep, 1, 5)) + '-' + RTRIM(SUBSTRING(fo.cep,6,3)) AS cep, 
	fo.logradouro, fo.numero, fo.bairro, fo.cidade, fo.estado 
	FROM fornecedor fo
	WHERE fo.cnpj = @cnpj
	ORDER BY fo.nome 
RETURN
END

SELECT * FROM fn_pesquisarfornecedor('37207672000182')
SELECT RTRIM(SUBSTRING(cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpj, 13, 2)) AS cnpj, nome, CONCAT('(', SUBSTRING(telefone, 1, 2), ') ', SUBSTRING(telefone, 3, 5), '-', SUBSTRING(telefone, 8, 4)) AS telefone, email, RTRIM(SUBSTRING(cep, 1, 5)) + '-' + RTRIM(SUBSTRING(cep,6,3)) AS cep, logradouro, numero, bairro, cidade, estado FROM fornecedor WHERE cnpj = 37207672000182
--Function buscando fornecedor por NOME
GO
CREATE FUNCTION fn_buscarfornecedor(@nome VARCHAR(100))
RETURNS @table table(
cnpj CHAR(18),  					
nome VARCHAR(100),   			
telefone CHAR(15),              	
email VARCHAR(100),			
cep CHAR(9),               		
logradouro VARCHAR(100),   				
numero INT,               			
bairro VARCHAR(50),					
cidade VARCHAR(50),					
estado VARCHAR(2)	
)
AS
BEGIN
	INSERT INTO @table (cnpj, nome, telefone, email, cep, logradouro, numero, bairro, cidade, estado)
	SELECT RTRIM(SUBSTRING(fo.cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(fo.cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(fo.cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(fo.cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(fo.cnpj, 13, 2)) AS CNPJ, 
	fo.nome, 
	CONCAT('(', SUBSTRING(fo.telefone, 1, 2), ') ', SUBSTRING(fo.telefone, 3, 5), '-', SUBSTRING(fo.telefone, 8, 4)) AS  telefone, 
	fo.email, 
	RTRIM(SUBSTRING(fo.cep, 1, 5)) + '-' + RTRIM(SUBSTRING(fo.cep,6,3)) AS cep, 
	fo.logradouro, fo.numero, fo.bairro, fo.cidade, fo.estado 
	FROM fornecedor fo
	WHERE fo.nome LIKE '%' + @nome + '%'
	ORDER BY fo.nome 
RETURN
END

SELECT * FROM fn_buscarfornecedor('Andreia')

--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (PRODUTO) -----------------------------------------------
GO
CREATE PROCEDURE sp_manter_produto (@opcao CHAR(1), @codigo INT, @nome VARCHAR(100), @quantidade INT, @vencimento DATE, @marca VARCHAR(30), @categoria VARCHAR(50),  @cnpjFornecedor CHAR(14), @nomeFornecedor VARCHAR(100), @dataCompra DATE, @valorUnitario DECIMAL(7,2), @descricao VARCHAR(100), @saida VARCHAR(255) OUTPUT
)
AS
BEGIN
	IF (UPPER(@opcao) = 'D' AND @codigo IS NOT NULL)
	BEGIN
	DELETE FROM produto WHERE codigo = @codigo
		SET @saida = 'Produto com o código: ' + CAST(@codigo AS VARCHAR(20)) + ' excluído'
	END
	ELSE
	BEGIN
		IF (UPPER(@opcao) = 'D' AND @codigo IS NULL)
		BEGIN
			RAISERROR('Fornecedor não encontrado', 16, 1)
		END
		ELSE
		BEGIN
			IF (UPPER(@opcao) = 'I')
			BEGIN

				INSERT INTO produto(codigo, nome, quantidade, vencimento, marca, categoria, cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao )
				VALUES (@codigo, @nome, @quantidade, @vencimento, @marca, @categoria, @cnpjFornecedor, @nomeFornecedor, @dataCompra, @valorUnitario, @descricao)
        
				SET @saida = 'Produto cadastrado'
			END
			ELSE
		BEGIN
		IF (UPPER(@opcao) = 'U')
			BEGIN
			UPDATE produto
			SET codigo = @codigo, nome = @nome, quantidade = @quantidade, vencimento = @vencimento, marca = @marca, categoria = @categoria, cnpjFornecedor = @cnpjFornecedor, nomeFornecedor = @nomeFornecedor, dataCompra = @dataCompra, valorUnitario = @valorUnitario, descricao = @descricao
			WHERE codigo = @codigo
          
			SET @saida = 'Produto com o código: ' + CAST(@codigo AS VARCHAR(15)) + ' atualizado'
			END
		ELSE
        BEGIN
          RAISERROR('Operação Inválida', 16, 1)
        END
      END
    END
  END
END

GO
DECLARE @saida1 VARCHAR(MAX)
EXEC sp_manter_produto 'I', 1001, 'Suco de Laranja', 12, '20/12/2023', 'Natural One', 'Bebidas', '37207672000182', 'Andreia e Bento Comercio de Bebidas ME', '10/10/2023', 5.99, 'Suco de laranja natural e fresco. Garrafa de 1.5L.', @saida1 OUTPUT
PRINT @saida1
GO
DECLARE @saida2 VARCHAR(MAX)
EXEC sp_manter_produto 'I', 2001, 'Arroz Branco', 20, '15/01/2024', 'Camil', 'Grãos', '84615822000177', 'Gabriel e Jaqueline Alimentos Ltda', '25/09/2023', 11.99, 'Arroz branco de alta qualidade. O peso de cada pacote pesa 5kg.', @saida2 OUTPUT
PRINT @saida2
GO
DECLARE @saida3 VARCHAR(MAX)
EXEC sp_manter_produto 'I', 3001, 'Iogurte Natural', 6, '17/12/2023', 'Nestle', 'Laticinios', '10181538000101', 'Claudia e Maya Laticinios Ltda', '02/10/2023', 2.99, 'Iogurte natural, sem adição de acucares ou conservantes. Cada um possui 170g', @saida3 OUTPUT
PRINT @saida3

SELECT * FROM produto
select * from fornecedor

--Function listando (READ)
GO
CREATE FUNCTION fn_listarproduto()
RETURNS @table TABLE(
codigo INT,
nome VARCHAR(100),
quantidade VARCHAR(100),
vencimento DATE, 
marca VARCHAR(30),
categoria VARCHAR(50),
cnpjFornecedor CHAR(18),
nomeFornecedor VARCHAR(100),
dataCompra DATE,
valorUnitario DECIMAL(7,2),
descricao VARCHAR(100)   	
)
AS
BEGIN
	INSERT INTO @table (codigo, nome, quantidade, vencimento, marca, categoria, cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao)
	SELECT p.codigo, p.nome, p.quantidade, 
	p.vencimento, p.marca, p.categoria, p.cnpjFornecedor, 
	p.nomeFornecedor, dataCompra, p.valorUnitario, p.descricao 
	FROM produto p
RETURN
END

--testando
SELECT codigo, nome, quantidade, 
	vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, 
	nomeFornecedor, dataCompra, valorUnitario, descricao 
FROM fn_listarproduto()
ORDER BY nome



--Function pesquisando PRODUTO por CODIGO
GO
CREATE FUNCTION fn_pesquisarproduto(@codigo INT)
RETURNS @table TABLE(
codigo INT,
nome VARCHAR(100),
quantidade VARCHAR(100),
vencimento DATE, 
marca VARCHAR(30),
categoria VARCHAR(50),
cnpjFornecedor CHAR(18),
nomeFornecedor VARCHAR(100),
dataCompra DATE,
valorUnitario DECIMAL(7,2),
descricao VARCHAR(100)   	
)
AS
BEGIN
	INSERT INTO @table (codigo, nome, quantidade, vencimento, marca, categoria, cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao)
	SELECT p.codigo, p.nome, p.quantidade, CONVERT(VARCHAR, p.vencimento, 103) AS vencimento, p.marca, p.categoria,
	RTRIM(SUBSTRING(p.cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(p.cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(p.cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(p.cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(p.cnpjFornecedor, 13, 2)) AS cnpjFornecedor, 
	p.nomeFornecedor, CONVERT (VARCHAR, p.dataCompra, 103) AS dataCompra, p.valorUnitario, p.descricao
	FROM produto p
	WHERE p.codigo = @codigo
	ORDER BY p.nome 
RETURN
END

SELECT * FROM fn_pesquisarproduto(1001)
SELECT nome, quantidade, vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao FROM produto WHERE codigo = 1001
--Function BUSCANDO PRODUTO por NOME
GO
CREATE FUNCTION fn_buscarproduto(@nome VARCHAR(100))
RETURNS @table TABLE(
codigo INT,
nome VARCHAR(100),
quantidade VARCHAR(100),
vencimento DATE, 
marca VARCHAR(30),
categoria VARCHAR(50),
cnpjFornecedor CHAR(18),
nomeFornecedor VARCHAR(100),
dataCompra DATE,
valorUnitario DECIMAL(7,2),
descricao VARCHAR(100)   	
)
AS
BEGIN
	INSERT INTO @table (codigo, nome, quantidade, vencimento, marca, categoria, cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao)
	SELECT p.codigo, p.nome, p.quantidade, CONVERT(VARCHAR, p.vencimento, 103) AS vencimento, p.marca, p.categoria,
	RTRIM(SUBSTRING(p.cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(p.cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(p.cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(p.cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(p.cnpjFornecedor, 13, 2)) AS cnpjFornecedor, 
	p.nomeFornecedor, CONVERT (VARCHAR, p.dataCompra, 103) AS dataCompra, p.valorUnitario, p.descricao
	FROM produto p
	WHERE p.nome LIKE '%' + @nome + '%'
	ORDER BY p.nome 
RETURN
END

SELECT * FROM fn_buscarproduto('Arroz')
SELECT nome, quantidade, vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao FROM produto WHERE nome LIKE '%arroz%'

--------------------------------------------------- INÍCIO PROCEDURES E FUNÇÕES (ESTOQUE) -----------------------------------------------
-- Procedure para movimentar o estoque (entrada ou saída)



--ok
GO
CREATE FUNCTION fn_prod(@codigo INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @nome				varchar(100),
			@valorUnitario		DECIMAL(7,2),
			@qtdEstoque			INT

		SELECT @nome = nome, @valorUnitario = valorUnitario, @qtdEstoque = quantidade FROM produto
		WHERE codigo = @codigo
	
	RETURN @qtdEstoque
END

--testando a function acima
SELECT dbo.fn_prod(2001) AS qtdEstoque

--Function que mostra o NIVEL DO ESTOQUE, tipo um listar) ok
GO
CREATE FUNCTION fn_tabelaestoque()
RETURNS @tabela TABLE (
codigo INT,
nome VARCHAR(100),
vencimento DATE,
marca VARCHAR(30),
cnpjFornecedor CHAR(18),
nomeFornecedor VARCHAR(100),
quantidade INT,
valorUnitario DECIMAL(7,2),            			   
nivel VARCHAR(20),
valorTotal DECIMAL(12,2)	   				
)
AS
BEGIN
	INSERT INTO @tabela (codigo, nome, vencimento, marca, cnpjFornecedor, nomeFornecedor, quantidade, valorUnitario)
	SELECT codigo, nome, vencimento, marca, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, nomeFornecedor,  quantidade, valorUnitario FROM produto

	UPDATE @tabela SET quantidade = (SELECT dbo.fn_prod(codigo))

	UPDATE @tabela SET nivel = 'Sem Estoque'
	WHERE quantidade = 0
	
	UPDATE @tabela SET nivel = 'Estoque Baixo'
	WHERE quantidade> 0 AND quantidade < 10

	UPDATE @tabela SET nivel = 'Estoque Moderado'
	WHERE quantidade >= 10 AND quantidade < 20

	UPDATE @tabela SET nivel = 'Estoque Alto'
	WHERE quantidade >= 20

	-- Calculando o valor total do item no estoque
    UPDATE @tabela SET valorTotal = quantidade * valorUnitario

	RETURN
END

--(tipo um listar)
SELECT * FROM fn_tabelaestoque()
ORDER BY quantidade ASC

SELECT * FROM fn_tabelaestoque()
ORDER BY vencimento ASC

SELECT codigo, nome, vencimento, marca, cnpjFornecedor, 
	   nomeFornecedor, quantidade, valorUnitario, nivel, valorTotal 
FROM fn_tabelaestoque() 
ORDER BY quantidade
--------------------------------------------------- SELECT (RELATÓRIO) ----------------------------------------------
SELECT 
    p.codigo, 
    p.nome, 
    p.vencimento, 
    p.marca, 
    RTRIM(SUBSTRING(f.cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(f.cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(f.cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(f.cnpj, 13, 2)) AS cnpjFornecedor, 
    f.nome AS nomeFornecedor, 
    p.quantidade, 
    p.valorUnitario, 
    p.quantidade * p.valorUnitario AS valorTotal
FROM produto p, fornecedor f
WHERE p.cnpjFornecedor = f.cnpj
		AND p.nomeFornecedor = f.nome
		AND p.vencimento >= '17/12/2023'
		AND p.vencimento <= '15/01/2024'
ORDER BY vencimento ASC

