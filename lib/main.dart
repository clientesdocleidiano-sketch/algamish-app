import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // =============================================================================
  // BLOCO 8: CONFIGURAÇÃO DE NUVEM ALGAMISH® (FIREBASE)
  // =============================================================================
  /*
    apiKey: "AIzaSyCGFK4wBtWTltMaxBSCej-8rBstJulXN4Q",
    projectId: "algamish-app",
    storageBucket: "algamish-app.firebasestorage.app",
    appId: "1:763722536566:web:505fdf32a4b5f63dc7b157"
  */

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const AlgamishGlobalApp());
}

class AlgamishGlobalApp extends StatelessWidget {
  const AlgamishGlobalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algamish Elite Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF001233),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001233),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AlgamishAuthGate(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

// =============================================================================
// BLOCO 0: PORTÃO DE ACESSO (LOGIN, CADASTRO & ESQUECI SENHA)
// =============================================================================
class AlgamishAuthGate extends StatefulWidget {
  const AlgamishAuthGate({super.key});
  @override
  State<AlgamishAuthGate> createState() => _AlgamishAuthGateState();
}

class _AlgamishAuthGateState extends State<AlgamishAuthGate> {
  bool _acessoLiberado = false;
  int _telaAtual = 0; // 0: Login, 1: Cadastro, 2: Esqueci Senha

  @override
  Widget build(BuildContext context) {
    if (_acessoLiberado) return const AlgamishMainFrame();
    return _buildTelaAuth();
  }

  Widget _buildTelaAuth() {
    return Scaffold(
      backgroundColor: const Color(0xFF001A3D),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF001A3D), Color(0xFF000814)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text("Algamish",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 65,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Amsterdam',
                      letterSpacing: -0.5)),
              Container(height: 1.2, width: 200, color: const Color(0xFFC9A063)),
              const SizedBox(height: 10),
              const Text("CONTABILIDADE & CONSULTORIA",
                  style: TextStyle(
                      color: Color(0xFFC9A063),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3.5)),
              const SizedBox(height: 60),

              if (_telaAtual == 0) _formLogin(),
              if (_telaAtual == 1) _formCadastro(),
              if (_telaAtual == 2) _formEsqueciSenha(),

              const SizedBox(height: 30),

              if (_telaAtual == 0) ...[
                TextButton(
                    onPressed: () => setState(() => _telaAtual = 1),
                    child: const Text("Novo por aqui? Cadastre-se",
                        style: TextStyle(color: Colors.white38))),
                TextButton(
                    onPressed: () => setState(() => _telaAtual = 2),
                    child: const Text("Esqueci minha senha",
                        style: TextStyle(color: Colors.white24, fontSize: 11))),
              ] else
                TextButton(
                    onPressed: () => setState(() => _telaAtual = 0),
                    child: const Text("Voltar ao Login",
                        style: TextStyle(color: Colors.white38))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formLogin() {
    return Column(children: [
      _loginField("USUÁRIO OU CNPJ", Icons.person_pin_outlined),
      const SizedBox(height: 25),
      _loginField("SENHA DE ACESSO", Icons.lock_outline, obscure: true),
      const SizedBox(height: 60),
      _btnAuth("ACESSAR PORTAL", () => setState(() => _acessoLiberado = true)),
    ]);
  }

  Widget _formCadastro() {
    return Column(children: [
      _loginField("NOME / RAZÃO SOCIAL", Icons.business),
      const SizedBox(height: 15),
      _loginField("CNPJ", Icons.badge_outlined),
      const SizedBox(height: 15),
      _loginField("SENHA", Icons.lock_outline, obscure: true),
      const SizedBox(height: 40),
      _btnAuth("FINALIZAR CADASTRO", () {
        _notificar("Dados enviados para Nuvem Algamish!");
        setState(() => _telaAtual = 0);
      }),
    ]);
  }

  Widget _formEsqueciSenha() {
    return Column(children: [
      const Text("RECUPERAR ACESSO",
          style: TextStyle(
              color: Color(0xFFC9A063),
              fontSize: 12,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      const Text(
          "Enviaremos um link de recuperação para o e-mail cadastrado neste CNPJ.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60, fontSize: 11)),
      const SizedBox(height: 30),
      _loginField("DIGITE O CNPJ", Icons.badge_outlined),
      const SizedBox(height: 40),
      _btnAuth("ENVIAR LINK", () {
        _notificar("Link enviado com sucesso!");
        setState(() => _telaAtual = 0);
      }),
    ]);
  }

  Widget _btnAuth(String t, VoidCallback p) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC9A063),
            foregroundColor: const Color(0xFF001A3D),
            minimumSize: const Size(double.infinity, 65),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18))),
        onPressed: p,
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _loginField(String label, IconData icon, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFC9A063)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 10),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white12)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC9A063))),
      ),
    );
  }

  void _notificar(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m), behavior: SnackBarBehavior.floating));
}

// =============================================================================
// BLOCO 1: FRAME PRINCIPAL (SEU CÓDIGO ORIGINAL PRESERVADO INTEGRALMENTE)
// =============================================================================
class AlgamishMainFrame extends StatefulWidget {
  const AlgamishMainFrame({super.key});
  @override
  State<AlgamishMainFrame> createState() => _AlgamishMainFrameState();
}

class _AlgamishMainFrameState extends State<AlgamishMainFrame> {
  int _abaAtiva = 0;
  final String _nomeEmpresa = "JOÃO DA SILVA PASTELARIA ME";
  final String _cnpjEmpresa = "12.345.678/0001-90";
  final List<Map<String, String>> _historicoNotas = [
    {"n": "Venda Consumidor", "d": "123.456.789-00", "v": "450,00", "s": "Emitida"},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      _buildID(),
      _buildGanhe(),
      _buildDocs(),
      _buildDAS(),
      _buildNotas(),
      _buildLoja(),
      _buildFinanceiro(),
    ];

    return Scaffold(
      body: IndexedStack(index: _abaAtiva, children: _telas),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
        child: BottomNavigationBar(
          currentIndex: _abaAtiva,
          onTap: (index) => setState(() => _abaAtiva = index),
          selectedItemColor: const Color(0xFF001233),
          unselectedItemColor: Colors.grey[400],
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.badge), label: "ID"),
            BottomNavigationBarItem(icon: Icon(Icons.stars), label: "Ganhe"),
            BottomNavigationBarItem(icon: Icon(Icons.folder_shared), label: "Docs"),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "DAS"),
            BottomNavigationBarItem(icon: Icon(Icons.add_task), label: "Notas"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Loja"),
            BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Pagar"),
          ],
        ),
      ),
    );
  }

  Widget _buildID() {
    return Scaffold(
      appBar: AppBar(title: const Text("ID Digital")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF001233), Color(0xFF002855)]),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("ALGAMISH® CORE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2)),
                        Icon(Icons.verified, color: Colors.blueAccent, size: 30),
                      ]),
                  const SizedBox(height: 50),
                  const Text("NOME EMPRESARIAL",
                      style: TextStyle(color: Colors.white38, fontSize: 10)),
                  Text(_nomeEmpresa,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text("CNPJ",
                      style: TextStyle(color: Colors.white38, fontSize: 10)),
                  Text(_cnpjEmpresa,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ]),
          ),
          const SizedBox(height: 30),
          _btnPremium(Icons.share, "COMPARTILHAR DADOS", () {
            Clipboard.setData(ClipboardData(
                text: "Empresa: $_nomeEmpresa\nCNPJ: $_cnpjEmpresa"));
            _notify("Dados copiados para o Sistema de Compartilhamento.");
          }),
        ]),
      ),
    );
  }

  Widget _buildGanhe() {
    return Scaffold(
      appBar: AppBar(title: const Text("Indique e Ganhe")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(children: [
            const Icon(Icons.auto_awesome, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            const Text("QUER R\$ 50,00 DE DESCONTO?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const Text("Indique amigos e acumule créditos na sua mensalidade.",
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!)),
              child: Column(children: [
                const Text("SEU LINK EXCLUSIVO:",
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 10),
                const Text("https://algamish.com.br/convite/joao123",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF001233))),
                const SizedBox(height: 20),
                _btnPremium(Icons.copy, "COPIAR LINK", () {
                  Clipboard.setData(const ClipboardData(
                      text: "https://algamish.com.br/convite/joao123"));
                  _notify("Link de convite copiado!");
                }),
              ]),
            ),
          ])),
    );
  }

  Widget _buildDocs() {
    final docs = [
      {"t": "Contrato Social.pdf", "d": "01/01/2026"},
      {"t": "Alvará 2026.pdf", "d": "15/02/2026"},
      {"t": "Cartão CNPJ.pdf", "d": "01/03/2026"},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Cofre de Documentos")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: docs.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text(docs[i]['t']!),
            subtitle: Text("Data: ${docs[i]['d']}"),
            trailing: const Icon(Icons.download),
            onTap: () => _notify("Baixando arquivo criptografado..."),
          ),
        ),
      ),
    );
  }

  Widget _buildDAS() {
    return Scaffold(
      appBar: AppBar(title: const Text("Impostos (DAS)")),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text("GUIA DO MÊS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: const Icon(Icons.warning, color: Colors.orange),
            title: const Text("Março/2026"),
            subtitle: const Text("Vencimento: 20/03/2026 - R\$ 72,00"),
            trailing: ElevatedButton(
              onPressed: () {
                Clipboard.setData(const ClipboardData(
                    text: "PIX-DAS-ALGAMISH-2026-KEY"));
                _notify("Código PIX DAS Copiado!");
              },
              child: const Text("PIX"),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text("HISTÓRICO DE PAGAMENTOS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("Fevereiro/2026"),
            subtitle: Text("Liquidado")),
        const ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("Janeiro/2026"),
            subtitle: Text("Liquidado")),
      ]),
    );
  }

  Widget _buildNotas() {
    final _nome = TextEditingController(),
        _doc = TextEditingController(),
        _val = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Notas Fiscais")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Text("DADOS DO CLIENTE",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 15),
          _input(_nome, "Razão Social / Nome do Cliente", Icons.person),
          _input(_doc, "CPF ou CNPJ", Icons.badge),
          _input(_val, "Valor Bruto (R\$)", Icons.monetization_on),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001233),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            onPressed: () {
              if (_nome.text.isNotEmpty) {
                setState(() => _historicoNotas.insert(0, {
                      "n": _nome.text,
                      "d": _doc.text,
                      "v": "R\$ ${_val.text}",
                      "s": "Processado"
                    }));
                _nome.clear();
                _doc.clear();
                _val.clear();
                _notify("Nota enviada para processamento!");
              }
            },
            child: const Text("SOLICITAR EMISSÃO AGORA",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 50),
          ..._historicoNotas
              .map((n) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                      leading: const Icon(Icons.receipt_long,
                          color: Color(0xFF001233)),
                      title: Text(n['n']!),
                      subtitle: Text("${n['d']} | ${n['v']}"),
                      trailing: const Text("OK",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)))))
              .toList(),
        ]),
      ),
    );
  }

  Widget _buildLoja() {
    final servicos = [
      {"t": "Alteração de CNAE", "p": "R\$ 350,00", "i": Icons.edit_note},
      {"t": "Certificado Digital A1", "p": "R\$ 229,00", "i": Icons.vpn_key},
      {"t": "Desenquadramento MEI", "p": "R\$ 550,00", "i": Icons.exit_to_app},
      {"t": "Parcelamento DAS", "p": "R\$ 180,00", "i": Icons.history_edu},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Loja de Serviços")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: servicos.length,
        itemBuilder: (ctx, i) => Card(
          margin: const EdgeInsets.only(bottom: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: Icon(servicos[i]['i'] as IconData,
                color: const Color(0xFF001233)),
            title: Text(servicos[i]['t'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(servicos[i]['p'] as String,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.add_shopping_cart),
            onTap: () => _notify("Serviço solicitado!"),
          ),
        ),
      ),
    );
  }

  Widget _buildFinanceiro() {
    return Scaffold(
      appBar: AppBar(title: const Text("Financeiro")),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text("MENSALIDADE PENDENTE",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: const Text("Honorários Março/2026"),
            subtitle: const Text("R\$ 150,00"),
            trailing: ElevatedButton(
                onPressed: () => _modalPagamento(context),
                child: const Text("PAGAR")),
          ),
        ),
      ]),
    );
  }

  void _modalPagamento(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (c) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("ESCOLHA O MÉTODO",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                ListTile(
                    leading: const Icon(Icons.pix, color: Colors.purple),
                    title: const Text("PIX Copia e Cola"),
                    onTap: () => Navigator.pop(c)),
                ListTile(
                    leading: const Icon(Icons.credit_card, color: Colors.blue),
                    title: const Text("Cartão de Crédito"),
                    onTap: () => Navigator.pop(c)),
                ListTile(
                    leading: const Icon(Icons.barcode_reader),
                    title: const Text("Boleto"),
                    onTap: () => Navigator.pop(c)),
                const SizedBox(height: 30),
              ],
            ));
  }

  Widget _input(TextEditingController c, String l, IconData i) => Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
          controller: c,
          decoration: InputDecoration(
              prefixIcon: Icon(i),
              labelText: l,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)))));

  Widget _btnPremium(IconData i, String l, VoidCallback p) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001233),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: p,
          icon: Icon(i),
          label: Text(l, style: const TextStyle(fontWeight: FontWeight.bold)));

  void _notify(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(m),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF001233)));
}
