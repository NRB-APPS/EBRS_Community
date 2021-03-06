class GenericBarcodesController < ApplicationController
  def new
  end

  def create
    print_and_redirect("/barcodes/label?barcode=#{params[:barcode]}&label=#{params[:label]}", '/clinic') 
  end

  def label
    label = ZebraPrinter::StandardLabel.new
    label.font_size = 2
    label.font_horizontal_multiplier = 1
    label.font_vertical_multiplier = 1
    label.left_margin = 50
    label.draw_barcode(50,180,0,1,3,12,120,false,"#{params[:barcode]}")
    label.draw_multi_text("#{(params[:label] || '').delete("'")}") #'
    data = label.print(1)
    send_data(data,
      :type=>"application/label; charset=utf-8", 
      :stream => false, 
      :filename => "#{@barcode}#{rand(10000)}.lbl", 
      :disposition => "inline")
  end  


end

