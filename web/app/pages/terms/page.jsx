import Head from "next/head";
import { Navbar } from "@/app/components/Navbar/page";
import { Footer } from "@/app/components/Footer/page";

export default function terms(){
  return (
    <>
    <Navbar/>
    <span className=" h-auto w-full">

    <div className="md:relative md:mt-auto mt-20">
    <div className="md:absolute  overflow-hidden bg-gradient-to-r from-[rgb(0,0,0,.8)] to-[rgb(255,255,255,.3)] object-cover rounded-t-md  w-full h-full " />
    <Head>
      <title >Terms and Conditions - Spend Wise</title>
    </Head>

    <div className="container mx-auto py-12 px-6 fontStyle shadow-md text-white">
      <h1 className="md:relative text-3xl font-bold mb-6 ">Terms and Conditions</h1>
      <div className="prose text-sm md:text-base lg:text-lg">
        <ol className="list-decimal pl-6 list-inside font-semibold text-xs md:relative">
          <li className="p-3">
            By using the Spend Wise app, you agree to comply with the terms
            and conditions outlined herein.
          </li>
          <li className="p-3">
            Spend Wise is designed for personal financial management and
            should not be used for any illegal or fraudulent activities.
          </li>
          <li className="p-3">
            Users are responsible for maintaining the security of their login
            credentials and should not share them with others.
          </li>
          <li className="p-3">
            Spend Wise may collect and store your personal information as
            outlined in our Privacy Policy.
          </li>
          <li className="p-3">
            The app is provided "as-is," and we do not guarantee uninterrupted
            or error-free service.
          </li>
          <li className="p-3">Users must be at least 18 years old to use the app.</li>
          <li className="p-3">
            You may not use Spend Wise in a way that interferes with the
            normal operation of the app or the server.
          </li>
          <li className="p-3">
            Spend Wise may use cookies and tracking technologies to improve
            the user experience.
          </li>
          <li className="p-3">
            Users are responsible for the accuracy of the information they
            input into the app.
          </li>
          <li className="p-3">
            We reserve the right to modify, suspend, or discontinue the app at
            any time.
          </li>
          <li className="p-3">
            Users are responsible for any fees associated with their financial
            accounts linked to Spend Wise.
          </li>
          <li className="p-3">
            Spend Wise is not a financial advisory service. Users should
            consult with a financial advisor for personalized financial
            advice.
          </li>
          <li className="p-3">
            We are not liable for any loss of data, financial losses, or
            damages resulting from the use of the app.
          </li>
          <li className="p-3">
            Users may not reverse engineer, decompile, or disassemble the app.
          </li>
          <li className="p-3">
            We reserve the right to suspend or terminate accounts for
            violations of these terms.
          </li>
          <li className="p-3">
            Users must report any security vulnerabilities or suspected
            breaches to us immediately.
          </li>
          <li className="p-3">
            Spend Wise may send notifications and updates to users through the
            app.
          </li>
          <li className="p-3">Users may not use the app for any unlawful purposes.</li>
          <li className="p-3">
            Spend Wise may display third-party advertisements or links. We are
            not responsible for the content of these third-party sites.
          </li>
          <li className="p-3">
            Users may not use the app for spamming, phishing, or any other
            malicious activities.
          </li>
          <li className="p-3">
            We may update these terms and conditions from time to time. Users
            will be notified of any changes.
          </li>
          <li className="p-3">
            Users may request the deletion of their account and associated
            data at any time.
          </li>
          <li className="p-3">
            If you have questions or concerns about these terms, please
            contact our support team.
          </li>
        </ol>
      </div>
    </div>
  </div>
    </span>
    <Footer/>
    </>
  );
}


