//
//  FolderView.swift
//  Final_Project
//
//  Created by nighthao on 2022/12/7.
//

import SwiftUI

struct FolderView: View {
    @Binding var my_places: [Place]
    @Binding var my_place_name:[Place_Name]
    var body: some View {
        VStack{
            Text("收藏地點").font(.largeTitle)
            Form{
                ForEach(my_place_name) { item in
                    
                    Text(item.name)
                    /*Button(action:{
                     my_places.remove(at: item)
                     my_place_name.remove(at: item)
                     
                     }, label: {
                     Image(systemName: "trash.fill")
                     })*/
                    
                }.onDelete(perform: removeRows)
            }
        }
    }
    func removeRows(at offsets: IndexSet){
        my_places.remove(atOffsets: offsets)
        my_place_name.remove(atOffsets: offsets)
    }
}

/*struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}*/
