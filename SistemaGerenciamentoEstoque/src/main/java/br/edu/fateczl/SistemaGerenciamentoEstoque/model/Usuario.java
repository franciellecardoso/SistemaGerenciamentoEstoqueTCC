package br.edu.fateczl.SistemaGerenciamentoEstoque.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Usuario {

	private String email;
	private String senha;
	private String tipo;
}
