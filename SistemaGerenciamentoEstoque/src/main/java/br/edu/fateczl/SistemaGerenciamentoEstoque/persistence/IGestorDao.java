package br.edu.fateczl.SistemaGerenciamentoEstoque.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Funcionario;

public interface IGestorDao {
	 public String cadastraFuncionario(Funcionario f) throws SQLException, ClassNotFoundException;
	 public String editaFuncionario(Funcionario f) throws SQLException, ClassNotFoundException;
	 public Funcionario pesquisaFuncionarioCpf(Funcionario f) throws SQLException, ClassNotFoundException;
	 public List<Funcionario> buscaFuncionarios(String nome) throws SQLException, ClassNotFoundException;
	 public List<Funcionario> listaFuncionario() throws SQLException, ClassNotFoundException;
}
