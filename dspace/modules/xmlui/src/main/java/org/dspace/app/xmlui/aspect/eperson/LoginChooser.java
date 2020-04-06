/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.eperson;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.AuthenticationUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.authenticate.AuthenticationManager;
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.core.ConfigurationManager;
import org.xml.sax.SAXException;

/**
 * Displays a list of authentication methods. This page is displayed if more
 * than one AuthenticationMethod is defined in the dpace config file.
 * 
 * @author Jay Paz
 * 
 */
public class LoginChooser extends AbstractDSpaceTransformer implements
		CacheableProcessingComponent {

	public static final Message T_dspace_home = message("xmlui.general.dspace_home");

	public static final Message T_title = message("xmlui.EPerson.LoginChooser.title");

	public static final Message T_trail = message("xmlui.EPerson.LoginChooser.trail");

	public static final Message T_head1 = message("xmlui.EPerson.LoginChooser.head1");

	public static final Message T_para1 = message("xmlui.EPerson.LoginChooser.para1");

	/**
	 * Generate the unique caching key. This key must be unique inside the space
	 * of this component.
	 */
	public Serializable getKey() {
		return null;
	}

	/**
	 * Generate the cache validity object.
	 */
	public SourceValidity getValidity() {
		return null;
	}

	/**
	 * Set the page title and trail.
	 */
	public void addPageMeta(PageMeta pageMeta) throws WingException {
		pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		pageMeta.addTrail().addContent(T_trail);
	}

	/**
	 * Display the login choices.
	 */
	public void addBody(Body body) throws SQLException, SAXException,
			WingException {
		Iterator authMethods = AuthenticationManager
				.authenticationMethodIterator();
		Request request = ObjectModelHelper.getRequest(objectModel);
		HttpSession session = request.getSession();

		// Get any message parameters
		String header = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_HEADER);
		String message = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_MESSAGE);
		String characters = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_CHARACTERS);

		if ( (header != null && header.trim().length() > 0) || 
			 (message != null && message.trim().length() > 0) ||
			 (characters != null && characters.trim().length() > 0)) {
			Division reason = body.addDivision("login-reason");

			if (header != null)
			{
				reason.setHead(message(header));
			}
			else
			{
				// Always have a head.
				reason.setHead("Authentication Required");
			}
			
			if (message != null)
			{
				reason.addPara(message(message));
			}
			
			if (characters != null)
			{
				reason.addPara(characters);
			}
		}

		Division loginChooser = body.addDivision("login-chooser");
		loginChooser.setHead(T_head1);
		loginChooser.addPara().addContent(T_para1);

		List list = loginChooser.addList("login-options", List.TYPE_SIMPLE);

		while (authMethods.hasNext()) {
			final AuthenticationMethod authMethod = (AuthenticationMethod) authMethods
					.next();

            HttpServletRequest hreq = (HttpServletRequest) this.objectModel
                    .get(HttpEnvironment.HTTP_REQUEST_OBJECT);

            HttpServletResponse hresp = (HttpServletResponse) this.objectModel
                    .get(HttpEnvironment.HTTP_RESPONSE_OBJECT);
            
            String loginURL = authMethod.loginPageURL(context, hreq, hresp);

            String authTitle = authMethod.loginPageTitle(context);

            if (loginURL != null && authTitle != null)
            {

                if (ConfigurationManager.getBooleanProperty("xmlui.force.ssl")
                        && !request.isSecure())
                {
                    StringBuffer location = new StringBuffer("https://");
                    location
                            .append(
                                    ConfigurationManager
                                            .getProperty("dspace.hostname"))
                            .append(loginURL).append(
                                    request.getQueryString() == null ? ""
                                            : ("?" + request.getQueryString()));
                    loginURL = location.toString();
                }

                final Item item = list.addItem();
                item.addXref(loginURL, message(authTitle));
            }

		}
	}

}
