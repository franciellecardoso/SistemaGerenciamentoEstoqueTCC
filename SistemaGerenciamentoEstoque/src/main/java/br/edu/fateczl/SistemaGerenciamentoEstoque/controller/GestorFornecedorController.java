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
public class GestorFornecedorController {
	@Autowired
	FornecedorDao foDao;

	@RequestMapping(name = "gestorFornecedor", value = "/gestorFornecedor", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("gestorFornecedor");
	}

	@RequestMapping(name = "gestorFornecedor", value = "/gestorFornecedor", method = RequestMethod.POST)
	public ModelAndView findFornecedores(@RequestParam Map<String, String> params, ModelMap model) {
		String cmd = params.get("button");
		List<Fornecedor> listaFornecedores = new ArrayList<Fornecedor>();
		Fornecedor fo = validaCampos(params, cmd);
		String saida = "";
		String erro = "";

		try {
			if (cmd.contains("Cadastrar")) {
				if (fo != null) {
					saida = foDao.cadastraFornecedor(fo);
					fo = new Fornecedor();
				}
			}
			if (cmd.contains("Atualizar")) {
				if (fo != null) {
					saida = foDao.editaFornecedor(fo);
					fo = new Fornecedor();
				}
			}
			if (cmd.contains("Excluir")) {
				if (fo != null) {
					saida = foDao.excluiFornecedor(fo);
					fo = new Fornecedor();
				}
			}
			if (cmd.contains("Consultar")) {
				if (fo != null) {
					fo = foDao.pesquisaFornecedor(fo);
				}
			}
			if (cmd.contains("Listar")) {
				listaFornecedores = foDao.listaFornecedores();
			}
		} catch (SQLException | ClassNotFoundException e) {
			erro = e.getMessage();
		} finally {
			model.addAttribute("saida", saida);
			model.addAttribute("erro", erro);
			model.addAttribute("fornecedores", fo);
			model.addAttribute("listaFornecedores", listaFornecedores);
		}
		return new ModelAndView("gestorFornecedor");
	}

	private Fornecedor validaCampos(Map<String, String> params, String cmd) {
		Fornecedor fo = new Fornecedor();
		if (cmd.contains("Cadastrar") || cmd.contains("Atualizar")) {
			if (!params.get("cnpj").trim().isEmpty() && !params.get("nome").trim().isEmpty()
					&& !params.get("telefone").trim().isEmpty() && !params.get("email").trim().isEmpty()
					&& !params.get("cep").trim().isEmpty() && !params.get("logradouro").trim().isEmpty()
					&& !params.get("numero").trim().isEmpty() && !params.get("bairro").trim().isEmpty()
					&& !params.get("cidade").trim().isEmpty() && !params.get("estado").trim().isEmpty()) {
				fo.setCnpj(params.get("cnpj").trim());
				fo.setNome(params.get("nome").trim());
				fo.setTelefone(params.get("telefone").trim());
				fo.setEmail(params.get("email").trim());
				fo.setCep(params.get("cep").trim());
				fo.setLogradouro(params.get("logradouro").trim());
				fo.setNumero(Integer.parseInt(params.get("numero").trim()));
				fo.setBairro(params.get("bairro").trim());
				fo.setCidade(params.get("cidade").trim());
				fo.setEstado(params.get("estado").trim());
			}
		}
		if (cmd.contains("Excluir") || cmd.contains("Consultar")) {
			if (!params.get("cnpj").trim().isEmpty()) {
				fo.setCnpj(params.get("cnpj").trim());
			}
		}
		return fo;
	}
}
