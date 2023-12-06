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

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Funcionario;

@Repository
public class GestorDao implements IGestorDao {

	@Autowired
	GenericDao gDao;

	@Override
	public String cadastraFuncionario(Funcionario f) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_funcionario(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "I");
		cs.setString(2, f.getCpf());
		cs.setString(3, f.getNome());
		cs.setString(4, f.getEmail());
		cs.setString(5, f.getSenha());
		cs.setInt(6, f.getCargo());
		cs.registerOutParameter(7, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public String editaFuncionario(Funcionario f) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "{CALL sp_manter_funcionario(?,?,?,?,?,?,?)}";
		CallableStatement cs = c.prepareCall(sql);
		cs.setString(1, "U");
		cs.setString(2, f.getCpf());
		cs.setString(3, f.getNome());
		cs.setString(4, f.getEmail());
		cs.setString(5, f.getSenha());
		cs.setInt(6, f.getCargo());
		cs.registerOutParameter(7, Types.VARCHAR);

		cs.execute();
		String saida = cs.getString(7);
		cs.close();
		c.close();

		return saida;
	}

	@Override
	public Funcionario pesquisaFuncionarioCpf(Funcionario f) throws SQLException, ClassNotFoundException {
		Connection c = gDao.getConnection();
		String sql = "SELECT nome, email, cargo FROM funcionario WHERE cpf = ?";
		PreparedStatement ps = c.prepareStatement(sql);
		ps.setString(1, f.getCpf());
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			f.setNome(rs.getString("nome"));
			f.setEmail(rs.getString("email"));
			f.setCargo(rs.getInt("cargo"));
		}
		rs.close();
		ps.close();
		c.close();
		return f;
	}

	@Override
	public List<Funcionario> buscaFuncionarios(String nome) throws SQLException, ClassNotFoundException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Funcionario> listaFuncionario() throws SQLException, ClassNotFoundException {
		List<Funcionario> funcionarios = new ArrayList<>();
		Connection c = gDao.getConnection();
		String sql = "SELECT RTRIM(SUBSTRING(cpf, 1, 3)) + '.' + RTRIM(SUBSTRING(cpf, 4, 3)) + '.' + RTRIM(SUBSTRING(cpf, 7, 3)) + '-' + RTRIM(SUBSTRING(cpf, 10, 2)) AS CPF,\r\n"
				+ "    nome, email, REPLICATE('*', LEN(senha)) AS senha, cargo\r\n" + "FROM fn_listarfuncionario()\r\n"
				+ "ORDER BY nome";
		PreparedStatement ps = c.prepareStatement(sql);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			Funcionario f = new Funcionario();
			f.setCpf(rs.getString("cpf"));
			f.setNome(rs.getString("nome"));
			f.setEmail(rs.getString("email"));
			f.setSenha(rs.getString("senha"));
			f.setCargo(rs.getInt("cargo"));

			funcionarios.add(f);
		}
		rs.close();
		ps.close();
		c.close();
		return funcionarios;
	}
}