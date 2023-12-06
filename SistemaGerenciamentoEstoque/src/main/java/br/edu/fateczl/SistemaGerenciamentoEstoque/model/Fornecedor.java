package br.edu.fateczl.SistemaGerenciamentoEstoque.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Fornecedor {

	private String cnpj;
	private String nome;
	private String telefone;
	private String email;
	private String cep;
	private String logradouro;
	private int numero;
	private String bairro;
	private String cidade;
	private String estado;
}
