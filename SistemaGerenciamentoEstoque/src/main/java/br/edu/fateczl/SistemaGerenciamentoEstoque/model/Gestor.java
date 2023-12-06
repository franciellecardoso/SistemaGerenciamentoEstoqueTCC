package br.edu.fateczl.SistemaGerenciamentoEstoque.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Gestor extends Usuario {

	private String cpf;
	private String nome;
	private String email;
	private int cargo;
	
}
