//
//  ViewController.swift
//  Preco do Bitcoin
//
//  Created by Victor Rodrigues Novais on 11/05/20.
//  Copyright © 2020 Victoriano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var precoBitCoin: UILabel!
    
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperarPrecoBitcoin()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recuperarPrecoBitcoin()
    }
    
    func formatarPreco(preco: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = nf.string(from: preco) {
            return precoFinal
        }
        
        return "0,00"
    }
    
    func recuperarPrecoBitcoin(){
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let tarefa = URLSession.shared.dataTask(with: url) {(dados, requisicao, erro) in
                if erro == nil {
                    
                    if let dadosRetorno = dados {
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                                
                                if let brl = objetoJson["BRL"] as? [String:Any] {
                                    if let preco = brl["buy"] as? Double {
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitCoin.text = "R$ \(precoFormatado)"
                                            self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                                
                            }
                        } catch {
                            print("Erro ao formatar o retorno.")
                        }
                    }
                    
                } else {
                    print("Erro ao fazer consulta do preço.")
                }
            }
            tarefa.resume()
        }
        
    }


}

