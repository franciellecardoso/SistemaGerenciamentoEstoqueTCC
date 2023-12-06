package br.edu.fateczl.SistemaGerenciamentoEstoque.controller;

import java.sql.Date;
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
public class ProdutoController {

	@Autowired
	ProdutoDao pDao;

	@RequestMapping(name = "produto", value = "/produto", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("produto");
	}

	@RequestMapping(name = "produto", value = "/produto", method = RequestMethod.POST)
	public ModelAndView findProdutos(@RequestParam Map<String, String> params, ModelMap model) {
		String cmd = params.get("button");
		List<Produto> listaProdutos = new ArrayList<Produto>();
		Produto p = validaCampos(params, cmd);
		String saida = "";
		String erro = "";

		try {
			if (cmd.contains("Cadastrar")) {
				if (p != null) {
					saida = pDao.cadastraProduto(p);
					p = new Produto();
				}
			}
			if (cmd.contains("Atualizar")) {
				if (p != null) {
					saida = pDao.editaProduto(p);
					p = new Produto();
				}
			}
			if (cmd.contains("Excluir")) {
				if (p != null) {
					saida = pDao.excluiProduto(p);
					p = new Produto();
				}
			}
			if (cmd.contains("Consultar")) {
				if (p != null) {
					p = pDao.pesquisaProduto(p);
				}
			}
			if (cmd.contains("Listar")) {
				listaProdutos = pDao.listaProduto();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
			model.addAttribute("produto", p);
			model.addAttribute("listaProdutos", listaProdutos);
		}
		return new ModelAndView("produto");
	}

	private Produto validaCampos(Map<String, String> params, String cmd) {
		Produto p = new Produto();
		if (cmd.contains("Cadastrar") || cmd.contains("Atualizar")) {
			if (!params.get("codigo").trim().isEmpty() && !params.get("nome").trim().isEmpty()
					&& !params.get("quantidade").trim().isEmpty() && !params.get("vencimento").trim().isEmpty()
					&& !params.get("marca").trim().isEmpty() && !params.get("categoria").trim().isEmpty()
					&& !params.get("cnpjFornecedor").trim().isEmpty() && !params.get("nomeFornecedor").trim().isEmpty()
					&& !params.get("dataCompra").trim().isEmpty() && !params.get("valorUnitario").trim().isEmpty()
					&& !params.get("descricao").trim().isEmpty()) {
				p.setCodigo(Integer.parseInt(params.get("codigo").trim()));
				p.setNome(params.get("nome").trim());
				p.setQuantidade(Integer.parseInt(params.get("quantidade").trim()));
				p.setVencimento(Date.valueOf(params.get("vencimento").trim()));
				p.setMarca(params.get("marca").trim());
				p.setCategoria(params.get("categoria").trim());
				p.setCnpjFornecedor(params.get("cnpjFornecedor").trim());
				p.setNomeFornecedor(params.get("nomeFornecedor").trim());
				p.setDataCompra(Date.valueOf(params.get("dataCompra").trim()));
				p.setValorUnitario(Float.parseFloat(params.get("valorUnitario").trim()));
				p.setDescricao(params.get("descricao").trim());
			}
		}
		if (cmd.contains("Excluir") || cmd.contains("Consultar")) {
			if (!params.get("codigo").trim().isEmpty()) {
				p.setCodigo(Integer.parseInt(params.get("codigo").trim()));
			}
		}
		return p;
	}
}
