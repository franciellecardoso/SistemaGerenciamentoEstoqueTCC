package br.edu.fateczl.SistemaGerenciamentoEstoque.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.ResourceUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import br.edu.fateczl.SistemaGerenciamentoEstoque.persistence.GenericDao;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperRunManager;
import net.sf.jasperreports.engine.util.JRLoader;

@Controller
public class RelatorioController {

	@Autowired
	GenericDao gDao;

	@RequestMapping(name = "relatorio", value = "/relatorio", method = RequestMethod.GET)
	public ModelAndView init(ModelMap model) {
		return new ModelAndView("relatorio");
	}

	@RequestMapping(name = "relatorio", value = "/relatorio", method = RequestMethod.POST)
	public ModelAndView post(ModelMap model) {
		return new ModelAndView("relatorio");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(name = "geraRelatorio", value = "/geraRelatorio", method = RequestMethod.POST)
	public ResponseEntity geraRelatorio(@RequestParam Map<String, String> params) {
		String erro = "";
		String vencimento = params.get("vencimento");
		String outroVencimento = params.get("outroVencimento"); // Novo parâmetro
		String botao = params.get("botao");

		Map<String, Object> paramsEntradaRelatorio = new HashMap<String, Object>();
		paramsEntradaRelatorio.put("vencimento", vencimento);
		 paramsEntradaRelatorio.put("outroVencimento", outroVencimento); // Adiciona o novo parâmetro

		byte[] bytes = null;

		// Inicializando elementos do response
		InputStreamResource resource = null;
		HttpStatus status = null;
		HttpHeaders header = new HttpHeaders();

		try {
			if (botao.equalsIgnoreCase("gerar")) {

				System.out.println(paramsEntradaRelatorio);
				Connection conn = gDao.getConnection();
				System.out.println(conn);
				File arquivo = ResourceUtils.getFile("classpath:reports/relatorioEstoque.jasper");
				System.out.println(arquivo);
				JasperReport report = (JasperReport) JRLoader.loadObjectFromFile(arquivo.getAbsolutePath());
				System.out.println(report);
				bytes = JasperRunManager.runReportToPdf(report, paramsEntradaRelatorio, conn);
				System.out.println(bytes);
			}
		} catch (ClassNotFoundException | SQLException | FileNotFoundException | JRException | NullPointerException e) {
			e.printStackTrace();
			erro = e.getMessage();
			status = HttpStatus.BAD_GATEWAY;
		} finally {
			if (erro.equals("")) {
				InputStream inputStream = new ByteArrayInputStream(bytes);
				resource = new InputStreamResource(inputStream);
				header.setContentLength(bytes.length);
				header.setContentType(MediaType.APPLICATION_PDF);
				status = HttpStatus.OK;
			}
		}

		return new ResponseEntity(resource, header, status);

	}
}
