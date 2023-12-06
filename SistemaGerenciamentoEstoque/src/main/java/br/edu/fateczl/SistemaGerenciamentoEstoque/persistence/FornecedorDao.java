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

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Fornecedor;

@Repository
public class FornecedorDao implements IFornecedorDao {

	@Autowired
	GenericDao gDao;

	// ----------------------------- [FORNECEDOR]---------------------------//
	@Override
	public String cadastraFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_fornecedor(?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setString(2, fo.getCnpj());
		cs.setString(3, fo.getNome());
		cs.setString(4, fo.getTelefone());
		cs.setString(5, fo.getEmail());
		cs.setString(6, fo.getCep());
		cs.setString(7, fo.getLogradouro());
		cs.setInt(8, fo.getNumero());
		cs.setString(9, fo.getBairro());
		cs.setString(10, fo.getCidade());
		cs.setString(11, fo.getEstado());
		cs.registerOutParameter(12, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(12);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public String editaFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_fornecedor(?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setString(2, fo.getCnpj());
		cs.setString(3, fo.getNome());
		cs.setString(4, fo.getTelefone());
		cs.setString(5, fo.getEmail());
		cs.setString(6, fo.getCep());
		cs.setString(7, fo.getLogradouro());
		cs.setInt(8, fo.getNumero());
		cs.setString(9, fo.getBairro());
		cs.setString(10, fo.getCidade());
		cs.setString(11, fo.getEstado());
		cs.registerOutParameter(12, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(12);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public String excluiFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_fornecedor(?,?,?,?,?,?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "D");
		cs.setString(2, fo.getCnpj());
		cs.setString(3, fo.getNome());
		cs.setString(4, fo.getTelefone());
		cs.setString(5, fo.getEmail());
		cs.setString(6, fo.getCep());
		cs.setString(7, fo.getLogradouro());
		cs.setInt(8, fo.getNumero());
		cs.setString(9, fo.getBairro());
		cs.setString(10, fo.getCidade());
		cs.setString(11, fo.getEstado());
		cs.registerOutParameter(12, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(12);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public Fornecedor pesquisaFornecedor(Fornecedor fo) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT RTRIM(SUBSTRING(cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpj, 13, 2)) AS cnpj, nome, CONCAT('(', SUBSTRING(telefone, 1, 2), ') ', SUBSTRING(telefone, 3, 5), '-', SUBSTRING(telefone, 8, 4)) AS telefone, email, RTRIM(SUBSTRING(cep, 1, 5)) + '-' + RTRIM(SUBSTRING(cep,6,3)) AS cep, logradouro, numero, bairro, cidade, estado FROM fornecedor WHERE cnpj = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, fo.getCnpj());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			fo.setNome(rs.getString("nome"));
			fo.setTelefone(rs.getString("telefone"));
			fo.setEmail(rs.getString("email"));
			fo.setCep(rs.getString("cep"));
			fo.setLogradouro(rs.getString("logradouro"));
			fo.setNumero(rs.getInt("numero"));
			fo.setBairro(rs.getString("bairro"));
			fo.setCidade(rs.getString("cidade"));
			fo.setEstado(rs.getString("estado"));
		}
		rs.close();
		ps.close();
		c.close();
		return fo;
	}

	@Override
	public List<Fornecedor> listaFornecedores() throws SQLException, ClassNotFoundException {
		List<Fornecedor> fornecedores = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT RTRIM(SUBSTRING(cnpj, 1, 2)) + '.' + RTRIM(SUBSTRING(cnpj, 3, 3)) + '.' + RTRIM(SUBSTRING(cnpj, 6, 3)) + '/' + RTRIM(SUBSTRING(cnpj, 9, 4)) + '-' + RTRIM(SUBSTRING(cnpj, 13, 2)) AS CNPJ,\r\n"
				+ "	nome, \r\n"
				+ "    CONCAT('(', SUBSTRING(telefone, 1, 2), ') ', SUBSTRING(telefone, 3, 5), '-', SUBSTRING(telefone, 8, 4)) AS  telefone,\r\n"
				+ "	email, \r\n" + "	RTRIM(SUBSTRING(cep, 1, 5)) + '-' + RTRIM(SUBSTRING(cep,6,3)) AS cep, \r\n"
				+ "	logradouro, numero, bairro, cidade, estado\r\n" + "FROM fn_listarfornecedor()";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Fornecedor fo = new Fornecedor();
			fo.setCnpj(rs.getString("cnpj"));
			fo.setNome(rs.getString("nome"));
			fo.setTelefone(rs.getString("telefone"));
			fo.setEmail(rs.getString("email"));
			fo.setCep(rs.getString("cep"));
			fo.setLogradouro(rs.getString("logradouro"));
			fo.setNumero(rs.getInt("numero"));
			fo.setBairro(rs.getString("bairro"));
			fo.setCidade(rs.getString("cidade"));
			fo.setEstado(rs.getString("estado"));

			fornecedores.add(fo);
		}
		rs.close();
		ps.close();
		c.close();

		return fornecedores;
	}

	@Override
	public List<Fornecedor> buscaFornecedores(String nome) throws SQLException, ClassNotFoundException {
		List<Fornecedor> fornecedor = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT cnpj, nome, telefone, email, cep, logradouro, numero, bairro, cidade, estado FROM fornecedor WHERE nome LIKE ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, "%" + nome + "%");
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Fornecedor fo = new Fornecedor();
			fo.setCnpj(rs.getString("cnpj"));
			fo.setNome(rs.getString("nome"));
			fo.setTelefone(rs.getString("telefone"));
			fo.setEmail(rs.getString("email"));
			fo.setCep(rs.getString("cep"));
			fo.setLogradouro(rs.getString("logradouro"));
			fo.setNumero(rs.getInt("numero"));
			fo.setBairro(rs.getString("bairro"));
			fo.setCidade(rs.getString("cidade"));
			fo.setEstado(rs.getString("estado"));

			fornecedor.add(fo);
		}
		rs.close();
		ps.close();
		c.close();

		return fornecedor;
	}

}
