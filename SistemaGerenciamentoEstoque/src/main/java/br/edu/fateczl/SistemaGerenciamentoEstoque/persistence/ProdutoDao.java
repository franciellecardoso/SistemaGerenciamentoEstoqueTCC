package br.edu.fateczl.SistemaGerenciamentoEstoque.persistence;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Produto;

@Repository
public class ProdutoDao implements IProdutoDao {

	@Autowired
	GenericDao gDao;

	// ----------------------------- [PRODUTO]---------------------------//
	@Override
	public String cadastraProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_produto (?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setInt(2, p.getCodigo());
		cs.setString(3, p.getNome());
		cs.setInt(4, p.getQuantidade());
		cs.setDate(5, p.getVencimento());
		cs.setString(6, p.getMarca());
		cs.setString(7, p.getCategoria());
		cs.setString(8, p.getCnpjFornecedor());
		cs.setString(9, p.getNomeFornecedor());
		cs.setDate(10, p.getDataCompra());
		cs.setFloat(11, p.getValorUnitario());
		cs.setString(12, p.getDescricao());
		cs.registerOutParameter(13, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(13);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public String editaProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_produto (?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setInt(2, p.getCodigo());
		cs.setString(3, p.getNome());
		cs.setInt(4, p.getQuantidade());
		cs.setDate(5, p.getVencimento());
		cs.setString(6, p.getMarca());
		cs.setString(7, p.getCategoria());
		cs.setString(8, p.getCnpjFornecedor());
		cs.setString(9, p.getNomeFornecedor());
		cs.setDate(10, p.getDataCompra());
		cs.setFloat(11, p.getValorUnitario());
		cs.setString(12, p.getDescricao());
		cs.registerOutParameter(13, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(13);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public String excluiProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_produto (?,?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setInt(2, p.getCodigo());
		cs.setString(3, p.getNome());
		cs.setInt(4, p.getQuantidade());
		cs.setDate(5, p.getVencimento());
		cs.setString(6, p.getMarca());
		cs.setString(7, p.getCategoria());
		cs.setString(8, p.getCnpjFornecedor());
		cs.setString(9, p.getNomeFornecedor());
		cs.setDate(10, p.getDataCompra());
		cs.setFloat(11, p.getValorUnitario());
		cs.setString(12, p.getDescricao());
		cs.registerOutParameter(13, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(13);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public Produto pesquisaProduto(Produto p) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT nome, quantidade, vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao FROM produto WHERE codigo = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setInt(1, p.getCodigo());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			p.setNome(rs.getString("nome"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCategoria(rs.getString("categoria"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setDataCompra(rs.getDate("dataCompra"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setDescricao(rs.getString("descricao"));

		}
		rs.close();
		ps.close();
		c.close();
		return p;
	}

	@Override
	public List<Produto> buscaProdutos(String nome) throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT nome, quantidade, vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, nomeFornecedor, dataCompra, valorUnitario, descricao FROM produto WHERE nome LIKE ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, "%" + nome + "%");
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Produto p = new Produto();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCategoria(rs.getString("categoria"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setDataCompra(rs.getDate("dataCompra"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setDescricao(rs.getString("descricao"));

			produtos.add(p);
		}
		rs.close();
		ps.close();
		c.close();
		return produtos;

	}

	@Override
	public List<Produto> listaProduto() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, quantidade, \r\n"
				+ "	vencimento, marca, categoria, RTRIM(SUBSTRING(cnpjFornecedor, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpjFornecedor, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpjFornecedor, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpjFornecedor, 13, 2)) AS cnpjFornecedor, \r\n"
				+ "	nomeFornecedor, dataCompra, valorUnitario, descricao \r\n" + "FROM fn_listarproduto()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Produto p = new Produto();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCategoria(rs.getString("categoria"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setDataCompra(rs.getDate("dataCompra"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setDescricao(rs.getString("descricao"));

			produtos.add(p);
		}
		rs.close();
		ps.close();
		c.close();
		return produtos;
	}

	// ----------------------------- [ESTOQUE]---------------------------//
	@Override
	public List<Produto> listaEstoque() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, vencimento, marca, cnpjFornecedor, \r\n"
				+ "	   nomeFornecedor, quantidade, valorUnitario, nivel, valorTotal \r\n"
				+ "FROM fn_tabelaestoque() \r\n" + "ORDER BY quantidade";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Produto p = new Produto();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setNivel(rs.getString("nivel"));
			p.setValorTotal(rs.getFloat("valorTotal"));

			produtos.add(p);
		}
		rs.close();
		ps.close();
		c.close();
		return produtos;
	}

	@Override
	public List<Produto> listaEstoqueVencimento() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, vencimento, marca, cnpjFornecedor, \r\n"
				+ "	   nomeFornecedor, quantidade, valorUnitario, nivel, valorTotal \r\n"
				+ "FROM fn_tabelaestoque() \r\n" + "ORDER BY vencimento";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Produto p = new Produto();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setNivel(rs.getString("nivel"));
			p.setValorTotal(rs.getFloat("valorTotal"));

			produtos.add(p);
		}
		rs.close();
		ps.close();
		c.close();
		return produtos;
	}
	
	// ----------------------------- [RELATÓRIO]---------------------------//
	@Override
	public List<Produto> exibeRelatorio() throws SQLException, ClassNotFoundException {
		List<Produto> produtos = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT codigo, nome, vencimento, marca, cnpjFornecedor, \r\n"
				+ "	   nomeFornecedor, quantidade, valorUnitario, valorTotal \r\n"
				+ "FROM fn_tabelaestoque() \r\n"
				+ "ORDER BY vencimento";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Produto p = new Produto();
			p.setCodigo(rs.getInt("codigo"));
			p.setNome(rs.getString("nome"));
			p.setVencimento(rs.getDate("vencimento"));
			p.setMarca(rs.getString("marca"));
			p.setCnpjFornecedor(rs.getString("cnpjFornecedor"));
			p.setNomeFornecedor(rs.getString("nomeFornecedor"));
			p.setQuantidade(rs.getInt("quantidade"));
			p.setValorUnitario(rs.getFloat("valorUnitario"));
			p.setValorTotal(rs.getFloat("valorTotal"));

			produtos.add(p);
		}
		rs.close();
		ps.close();
		c.close();
		return produtos;
	}

}
