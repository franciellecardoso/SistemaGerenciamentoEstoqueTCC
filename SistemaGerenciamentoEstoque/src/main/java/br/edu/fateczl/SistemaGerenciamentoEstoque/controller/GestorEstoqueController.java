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

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Produto;
import br.edu.fateczl.SistemaGerenciamentoEstoque.persistence.ProdutoDao;

@Controller
public class GestorEstoqueController {
	@Autowired
	ProdutoDao pDao;

	@RequestMapping(name = "gestorEstoque", value = "/gestorEstoque", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("gestorEstoque");
	}

	@RequestMapping(name = "gestorEstoque", value = "/gestorEstoque", method = RequestMethod.POST)
	public ModelAndView findProduto(@RequestParam Map<String, String> params, ModelMap model) {
		String cmd = params.get("button");
		List<Produto> listaEstoque = new ArrayList<Produto>();
		String saida = "";
		String erro = "";

		try {
			if (cmd.contains("Por Nivel")) {
				listaEstoque = pDao.listaEstoque();
			}
			if (cmd.contains("Por Vencimento")) {
				listaEstoque = pDao.listaEstoqueVencimento();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
			model.addAttribute("listaEstoque", listaEstoque);
		}
		return new ModelAndView("gestorEstoque");
	}
}
