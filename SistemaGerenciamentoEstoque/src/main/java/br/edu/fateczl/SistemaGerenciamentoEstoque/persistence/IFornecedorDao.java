package br.edu.fateczl.SistemaGerenciamentoEstoque.persistence;

import java.sql.SQLException;
import java.util.List;

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Fornecedor;

public interface IFornecedorDao {
	public String cadastraFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException;
	public String editaFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException;
	public String excluiFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException;
	public Fornecedor pesquisaFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException;
	public List<Fornecedor> buscaFornecedores(String nome) throws SQLException, ClassNotFoundException;
	public List<Fornecedor> listaFornecedores() throws SQLException, ClassNotFoundException;


}
