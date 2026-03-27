import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';

void main (){
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // .system é o correto. Light para teste.
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // ouvinte
    super.initState();
      _passwordController.addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // evita que o listener fique conectado
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
  Clipboard.setData(ClipboardData(text: password));
  ScaffoldMessenger.of(
  context,
  ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

    void generatePassword() {
    const upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const lower = "abcdefghijklmnopqrstuvwxyz";
    const numbers = "0123456789";
    const symbols = "!@#\$%&*";
    final chars = upper + lower + numbers + symbols;
    final random = Random();
    setState(() {
    _passwordController.text = List.generate(
      12,
    (_) => chars[random.nextInt(chars.length)],
    ).join();
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
        Column(
          //////////// imagem
          children: [
            Expanded(child: Column( children: [
              ClipOval(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/ironman.jpg")),
              ),
              //////////
              ////////////// Titulo
              SizedBox(height: 16),
              Text(
                "Sua senha segura",
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 24
                  ),
              ),
              //////////
              /////////////Senha
                SizedBox(height: 16),
                TextField(
                  maxLength: 12,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: _passwordController.text.isNotEmpty 
                    ? IconButton(
                      onPressed: (){
                      copyPassword(_passwordController.text);
                    }, 
                    icon: Icon(Icons.copy)) : null,
                  ),
                ),
                Text(_passwordController.text)
            ])
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () {}, child: Text("Gerar Senha")))
          ],
        )
      ),
    );
  }
}