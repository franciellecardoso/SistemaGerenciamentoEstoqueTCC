package br.edu.fateczl.SistemaGerenciamentoEstoque.controller;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.SistemaGerenciamentoEstoque.model.Usuario;
import br.edu.fateczl.SistemaGerenciamentoEstoque.persistence.LoginDao;

@Controller
public class LoginController {

	@Autowired
	private LoginDao uDao;

	@RequestMapping(name = "index", value = "/index", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("index");
	}

	@RequestMapping(name = "index", value = "/index", method = RequestMethod.POST)
	public String realizarLogin(@RequestParam Map<String, String> params, ModelMap model)
			throws SQLException, ClassNotFoundException {
		Usuario u = new Usuario();

		String email = params.get("email");
		String senha = params.get("senha");
		String botao = params.get("btn");

		String view = "";

		if (botao.equalsIgnoreCase("Entrar")) {
			u = uDao.getLogin(email, senha);

			System.out.println(u.getEmail());

			if (u.getTipo().equalsIgnoreCase("G")) {
				view = "redirect:/hub";
			} 
			 else if (u.getTipo().equalsIgnoreCase("F")) {
				view = "redirect:/intro";
			}
		}
		return view;
	}
}
