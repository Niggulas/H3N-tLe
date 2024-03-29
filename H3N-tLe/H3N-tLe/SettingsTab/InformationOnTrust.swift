//
//  InformationOnTrust.swift
//  H3N-tLe
//
//  Created by Nikolas Huber on 22.06.22.
//

import SwiftUI

struct InformationOnTrust: View {
    var body: some View {
		ScrollView {
			Text("Be careful with your passwords\n")
				.font(.title)
			Text("If the website of which you want to download something requires you to sign in to an account, please make shure that the plugin used to execute the download is from a trust worthy developer and or publisher.\n\nIt is a good sign if the plugin is completely open source, but even that doesn't provide guaranteed safety as long as you don't understand every line of it's code.\n\nIf you don't trust us, feel free to check out the source code for this app in GitHub.\n\nAnd if you just can't trust anybody or you are interested in coding, go ahead and develope your own plugins.\nAnd when they work, you can publish them on GitHub for other people to use, to contribute something to this project")
				.padding(.horizontal, 8)
			
			Spacer()
		}
    }
}

struct InformationOnTrust_Previews: PreviewProvider {
    static var previews: some View {
		InformationOnTrust()
			.preferredColorScheme(.dark)
			.previewDevice("iPhone 11")
			
    }
}
