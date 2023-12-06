package br.edu.fateczl.SistemaGerenciamentoEstoque.model;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Produto {

	private int codigo;
	private String nome;
	private int quantidade;
	private Date vencimento;
	private String marca;
	private String categoria;
	private String cnpjFornecedor;
	private String nomeFornecedor;
	private Date dataCompra;
	private float valorUnitario;
	private String descricao;
	private float valorTotal;
	private String nivel;
	
}
