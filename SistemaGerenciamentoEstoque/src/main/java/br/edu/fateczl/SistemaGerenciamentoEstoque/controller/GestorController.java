package br.edu.fateczl.SistemaGerenciamentoEstoque.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Funcionario;
import br.edu.fateczl.SistemaGerenciamentoEstoque.persistence.GestorDao;

@Controller
public class GestorController {

	@Autowired
	GestorDao geDao;

	@RequestMapping(name = "gestor", value = "/gestor", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("gestor");
	}

	@RequestMapping(name = "gestor", value = "/gestor", method = RequestMethod.POST)
	public ModelAndView findFuncionario(@RequestParam Map<String, String> params, ModelMap model) {
		String cmd = params.get("button");
		List<Funcionario> listaFuncionario = new ArrayList<Funcionario>();
		Funcionario f = validaCampos(params, cmd);
		String saida = "";
		String erro = "";

		try {
			if (cmd.contains("Cadastrar")) {
				if (f != null) {
					saida = geDao.cadastraFuncionario(f);
					f = new Funcionario();
				}
			}
			if (cmd.contains("Atualizar")) {
				if (f != null) {
					saida = geDao.editaFuncionario(f);
					f = new Funcionario();
				}
			}
			if (cmd.contains("Consultar")) {
				if (f != null) {
					f = geDao.pesquisaFuncionarioCpf(f);
				}
			}
			if (cmd.contains("Listar")) {
				listaFuncionario = geDao.listaFuncionario();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
			model.addAttribute("funcionario", f);
			model.addAttribute("listaFuncionario", listaFuncionario);
		}
		return new ModelAndView("gestor");
	}

	private Funcionario validaCampos(Map<String, String> params, String cmd) {
		Funcionario f = new Funcionario();
		if (cmd.contains("Cadastrar") || cmd.contains("Atualizar")) {
			if (!params.get("cpf").trim().isEmpty() && !params.get("nome").trim().isEmpty()
					&& !params.get("email").trim().isEmpty() && !params.get("senha").trim().isEmpty()
					&& !params.get("cargo").trim().isEmpty()) {
				f.setCpf(params.get("cpf").trim());
				f.setNome(params.get("nome").trim());
				f.setEmail(params.get("email").trim());
				f.setSenha(params.get("senha").trim());
				f.setCargo(Integer.parseInt(params.get("cargo").trim()));
			}
		}
		if (cmd.contains("Consultar")) {
			if (!params.get("cpf").trim().isEmpty()) {
				f.setCpf(params.get("cpf").trim());
			}
		}
		return f;
	}
}
