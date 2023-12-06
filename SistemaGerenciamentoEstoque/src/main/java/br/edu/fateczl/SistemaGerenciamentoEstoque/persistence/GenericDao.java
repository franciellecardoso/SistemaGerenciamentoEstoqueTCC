package br.edu.fateczl.SistemaGerenciamentoEstoque.persistence;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

@Repository
public class GenericDao {
	private Connection c;

	public Connection getConnection() throws ClassNotFoundException, SQLException {

		String hostName = "localhost";
		// atualizar a database
		String dbName = "tcc02";
		String user = "francielle";
		String senha = "123456";
		Class.forName("net.sourceforge.jtds.jdbc.Driver");
		String connect = String.format("jdbc:jtds:sqlserver://%s:1433;databaseName=%s;user=%s;password=%s", hostName,
				dbName, user, senha);
		c = DriverManager.getConnection(connect);

		return c;
	}
}
