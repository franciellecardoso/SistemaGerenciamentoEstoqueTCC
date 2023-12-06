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

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Fornecedor;
import br.edu.fateczl.SistemaGerenciamentoEstoque.persistence.FornecedorDao;

@Controller
public class FornecedorController {

	@Autowired
	FornecedorDao foDao;

	@RequestMapping(name = "fornecedores", value = "/fornecedores", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("fornecedores");
	}

	@RequestMapping(name = "fornecedores", value = "/fornecedores", method = RequestMethod.POST)
	public ModelAndView findFornecedores(@RequestParam Map<String, String> params, ModelMap model) {
		String cmd = params.get("button");
		List<Fornecedor> listaFornecedores = new ArrayList<Fornecedor>();
		String saida = "";
		String erro = "";

		try {
			if (cmd.contains("Listar")) {
				listaFornecedores = foDao.listaFornecedores();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
			model.addAttribute("listaFornecedores", listaFornecedores);
		}
		return new ModelAndView("fornecedores");
	}

}